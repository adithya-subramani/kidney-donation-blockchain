from flask import Flask,request, jsonify
from web3 import Web3
import json

app = Flask(__name__)

web3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))
web3.eth.default_account = web3.eth.accounts[0]

contract_json_path = 'build/contracts/DonorContract.json'

with open(contract_json_path, 'r') as json_file:
    contract_data = json.load(json_file)
    contract_abi = contract_data['abi']
    network_keys = list(contract_data['networks'].keys())
    contract_address = contract_data['networks'][network_keys[0]]['address']

MIN_GAS = 1000000

contract = web3.eth.contract(address=contract_address, abi=contract_abi)


@app.route('/')
def index():
    return "Good to go" if web3.is_connected() else "Problem"


@app.route('/register', methods=['POST'])
def register():
    user = request.form['user']
    fullname = request.form['fullname']
    age = int(request.form['age'])
    gender = request.form['gender']
    medical_id = request.form['medical_id']
    blood_type = request.form['blood_type']
    organ = request.form['organ']
    weight = int(request.form['weight'])
    height = int(request.form['height'])

    checked_values = check_input_values(
        user, fullname, age, gender, medical_id, organ, weight, height)

    if checked_values:
        validate = False

        if user == 'Pledge':
            validate = contract.functions.validatePledge(medical_id).call()
        elif user == 'Donor':
            validate = contract.functions.validateDonor(medical_id).call()
        elif user == 'Patient':
            validate = contract.functions.validatePatient(medical_id).call()

        if not validate:
            if user == 'Pledge':
                set_pledge(fullname, age, gender, medical_id,
                           blood_type, organ, weight, height)
            elif user == 'Donor':
                set_donor(fullname, age, gender, medical_id,
                          blood_type, organ, weight, height)
            elif user == 'Patient':
                set_patient(fullname, age, gender, medical_id,
                            blood_type, organ, weight, height)

            return jsonify({'message': 'Registration Successful!'}), 200
        else:
            return jsonify({'error': 'Medical ID already exists!'}), 400
    else:
        return jsonify({'error': 'Invalid input values!'}), 400


@app.route('/forward_pledge', methods=['POST'])
def forward_pledge():
    try:
        medical_id = request.form['pledge_medical_id']
        result = contract.functions.getPledge(medical_id).call()

        full_name = result[0]
        age = result[1]
        gender = result[2]
        blood_type = result[3]
        organ = result[4]
        weight = result[5]
        height = result[6]

        contract.functions.setDonors(
            full_name, age, gender, medical_id, blood_type, organ, weight, height).call()
        return jsonify({"status": "success", "message": "Registration Successful!"}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400


@app.route('/search', methods=['POST'])
def search():
    id = request.form['id']
    user = request.form['user']

    validate = False
    result = []
    if user == 'Pledge':
        validate = contract.functions.validatePledge(id).call()
    elif user == 'Patient':
        validate = contract.functions.validatePatient(id).call()

    if validate:
        if user == "Donor":
            result = contract.functions.getDonor(id).call()
        elif user == "Patient":
            result = contract.functions.getPatient(id).call()
    return result


@app.route('/view_pledges')
def view_pledges():
    try:
        PledgeCount = contract.functions.getCountOfPledges().call()
        PledgeIDs = contract.functions.getAllPledgeIDs().call()
        Pledges = []

        for i in range(PledgeCount):
            validate = contract.functions.validateDonor(PledgeIDs[i]).call()

            if not validate:
                result = contract.functions.getPledge(PledgeIDs[i]).call()
                data = {"Index": i + 1, "Full Name": result[0], "Age": result[1], "Gender": result[2],
                        "Medical ID": PledgeIDs[i], "Blood-Type": result[3], "Organ": result[4], "Weight": result[5],
                        "Height": result[6]}
                Pledges.append(data)

        if len(Pledges):
            return jsonify({"pledges": Pledges}), 200
        else:
            return jsonify({"status": "success", "message": "No pending pledges found!"}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400


@app.route('/view_donors')
def view_donors():
    try:
        Donors = get_donors()
        if len(Donors):
            return jsonify({"donors": Donors}), 200
        else:
            return jsonify({"status": "error", "message": "No pending donors found!"}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400


def get_donors():
    DonorCount = contract.functions.getCountOfDonors().call()
    DonorIDs = contract.functions.getAllDonorIDs().call()
    Donors = []

    for i in range(DonorCount):
        result = contract.functions.getDonor(DonorIDs[i]).call()
        data = {"Index": i + 1, "Full Name": result[0], "Age": result[1], "Gender": result[2],
                "Medical ID": DonorIDs[i], "Blood-Type": result[3], "Organ": result[4], "Weight": result[5],
                "Height": result[6]}
        Donors.append(data)
    return Donors


@app.route('/view_patients')
def view_patients():
    try:
        Patients = get_patients()
        if len(Patients):
            return jsonify({"patients": Patients}), 200
        else:
            return jsonify({"status": "error", "message": "No pending patients found!"}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400


def get_patients():
    PatientCount = contract.functions.getCountOfPatients().call()
    PatientIDs = contract.functions.getAllPatientIDs().call()
    Patients = []

    for i in range(PatientCount):
        result = contract.functions.getPatient(PatientIDs[i]).call()
        data = {"Index": i + 1, "Full Name": result[0], "Age": result[1], "Gender": result[2],
                "Medical ID": PatientIDs[i], "Blood-Type": result[3], "Organ": result[4], "Weight": result[5],
                "Height": result[6]}
        Patients.append(data)
    return Patients


@app.route('/transplant_match')
def transplant_match():
    try:
        patients = get_patients()
        donors = get_donors()
        print(patients)
        if (patients != [] and donors != []):
            matched = []
            for patient in patients:
                for donor in donors:
                    if (donor.get("is_matched") != "true"
                       and patient["Blood-Type"] == donor["Blood-Type"]
                       and patient["Organ"] == donor["Organ"]):
                        donor["is_matched"] = "true"
                        matched.append({"patient": patient, "donor": donor})

        if len(matched):
            return jsonify({"matched": matched})
        else:
            return jsonify({"status": "error", "message": "No potential matches!"})

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400


def check_input_values(user, fullname, age, gender, medical_id, organ, weight, height):
    if not fullname or not age or not gender or not medical_id or not organ or not weight or not height:
        return False

    if user == 'Pledge' and age < 18:
        return False
    elif not gender or not medical_id or not organ or not weight or not height:
        return False
    elif weight < 20 or weight > 200:
        return False
    elif height < 54 or height > 272:
        return False

    return True


def set_pledge(fullname, age, gender, medical_id, blood_type, organ, weight, height):
    contract.functions.setPledge(
        fullname, age, gender, medical_id, blood_type, organ, weight, height
    ).transact()


def set_donor(fullname, age, gender, medical_id, blood_type, organ, weight, height):
    contract.functions.setDonors(
        fullname, age, gender, medical_id, blood_type, organ, weight, height
    ).transact()


def set_patient(fullname, age, gender, medical_id, blood_type, organ, weight, height):
    contract.functions.setPatients(
        fullname, age, gender, medical_id, blood_type, organ, weight, height
    ).transact()


if __name__ == '__main__':
    app.run(debug=True)
