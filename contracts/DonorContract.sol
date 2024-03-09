// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DonorContract {
    struct pledged
    {
        string fullname;
        uint age;
        string gender;
        string medical_id;
        string blood_type;
        string organ;
        uint transplant_status;
        uint weight;
        uint height;
    }

    struct donor
    {
        string fullname;
        uint age;
        string gender;
        string medical_id;
        string blood_type;
        string organ;
        uint transplant_status;
        uint weight;
        uint height;
    }

    struct patient
    {
        string fullname;
        uint age;
        string gender;
        string medical_id;
        string blood_type;
        string organ;
        uint transplant_status;
        uint weight;
        uint height;
    }

    struct TransplantRecord {
        uint transplant_id;
        string donor_id;
        string patient_id;
        string organ;
        uint donor_type;
        uint timestamp;
    }


    mapping ( string =>pledged ) pledgedMap;
    mapping ( string =>donor ) donorMap;
    mapping ( string =>patient) patientMap;
    mapping (uint => TransplantRecord) public transplantRecords;

    string[] PledgedArray;
    string[] DonorsArray;
    string[] PatientsArray;
    uint[] TransplantsArray;
    uint public transplantRecordCount;

    function setPledge(string memory _fullname, uint _age, string memory _gender, string memory _medical_id,
                       string memory _blood_type, string memory _organ, uint _weight, uint _height)
    public
    {
        require ( keccak256(abi.encodePacked((pledgedMap[_medical_id].medical_id))) != keccak256(abi.encodePacked(_medical_id)));
        pledgedMap[_medical_id].fullname = _fullname;
        pledgedMap[_medical_id].age = _age;
        pledgedMap[_medical_id].gender = _gender;
        pledgedMap[_medical_id].medical_id = _medical_id;
        pledgedMap[_medical_id].blood_type = _blood_type;
        pledgedMap[_medical_id].organ = _organ;
        pledgedMap[_medical_id].weight = _weight;
        pledgedMap[_medical_id].height = _height;

        PledgedArray.push(_medical_id);
    }

    function setDonors(string memory _fullname, uint _age, string memory _gender, string memory _medical_id,
                       string memory _blood_type, string memory _organ, uint _weight, uint _height)
    public
    {
        require ( keccak256(abi.encodePacked((donorMap[_medical_id].medical_id))) != keccak256(abi.encodePacked(_medical_id)));
        donorMap[_medical_id].fullname = _fullname;
        donorMap[_medical_id].age = _age;
        donorMap[_medical_id].gender = _gender;
        donorMap[_medical_id].medical_id = _medical_id;
        donorMap[_medical_id].blood_type = _blood_type;
        donorMap[_medical_id].organ = _organ;
        donorMap[_medical_id].weight = _weight;
        donorMap[_medical_id].height = _height;

        DonorsArray.push(_medical_id);
    }

    function setPatients(string memory _fullname, uint _age, string memory _gender, string memory _medical_id,
                       string memory _blood_type, string memory _organ, uint _weight, uint _height)
    public
    {
        require ( keccak256(abi.encodePacked((donorMap[_medical_id].medical_id))) != keccak256(abi.encodePacked(_medical_id)));
        patientMap[_medical_id].fullname = _fullname;
        patientMap[_medical_id].age = _age;
        patientMap[_medical_id].gender = _gender;
        patientMap[_medical_id].medical_id = _medical_id;
        patientMap[_medical_id].blood_type = _blood_type;
        patientMap[_medical_id].organ = _organ;
        patientMap[_medical_id].weight = _weight;
        patientMap[_medical_id].height = _height;

        PatientsArray.push(_medical_id);
    }

    function getPledge(string memory _medical_id) view public returns(string memory, uint, string memory, string memory, string memory, uint, uint)
    {
        return
        (
            pledgedMap[_medical_id].fullname,
            pledgedMap[_medical_id].age,
            pledgedMap[_medical_id].gender,
            pledgedMap[_medical_id].blood_type,
            pledgedMap[_medical_id].organ,
            pledgedMap[_medical_id].weight,
            pledgedMap[_medical_id].height
        );
    }

    function getDonor(string memory _medical_id) view public returns(string memory, uint, string memory, string memory, string memory, uint, uint)
    {
        return
        (
            donorMap[_medical_id].fullname,
            donorMap[_medical_id].age,
            donorMap[_medical_id].gender,
            donorMap[_medical_id].blood_type,
            donorMap[_medical_id].organ,
            donorMap[_medical_id].weight,
            donorMap[_medical_id].height
        );
    }

    function getPatient(string memory _medical_id) view public returns(string memory, uint, string memory, string memory, string memory, uint, uint)
    {
        return
        (
            patientMap[_medical_id].fullname,
            patientMap[_medical_id].age,
            patientMap[_medical_id].gender,
            patientMap[_medical_id].blood_type,
            patientMap[_medical_id].organ,
            patientMap[_medical_id].weight,
            patientMap[_medical_id].height
        );
    }

    function addTransplantRecord(string memory _donorMedicalId, string memory _patientMedicalId, string memory _organ,uint _donor_type)
        public
    {
        require(validateDonor(_donorMedicalId), "Invalid donor medical ID");
        require(validatePatient(_patientMedicalId), "Invalid patient medical ID");

        uint timestamp = block.timestamp;

        transplantRecords[transplantRecordCount] = TransplantRecord({
            transplant_id: transplantRecordCount,
            donor_id: _donorMedicalId,
            patient_id: _patientMedicalId,
            organ: _organ,
            donor_type: _donor_type,
            timestamp: timestamp
        });

        donorMap[_donorMedicalId].transplant_status = 1;
        patientMap[_patientMedicalId].transplant_status = 1;

        TransplantsArray.push(transplantRecordCount);
        transplantRecordCount++;
    }

    function validatePledge(string memory _medical_id) view public returns(bool)
    {

     if ((keccak256(abi.encodePacked((pledgedMap[_medical_id].medical_id))) == keccak256(abi.encodePacked(_medical_id))) && pledgedMap[_medical_id].transplant_status != 1)
        return true;
     else return false;

    }

    function validateDonor(string memory _medical_id) view public returns(bool)
    {

     if ((keccak256(abi.encodePacked((donorMap[_medical_id].medical_id))) == keccak256(abi.encodePacked(_medical_id))) && donorMap[_medical_id].transplant_status != 1)
        return true;
     else return false;

    }

    function validatePatient(string memory _medical_id) view public returns(bool)
    {

     if ((keccak256(abi.encodePacked((patientMap[_medical_id].medical_id))) == keccak256(abi.encodePacked(_medical_id))) && patientMap[_medical_id].transplant_status != 1)
        return true;
     else return false;

    }

    function getAllPledgeIDs() view public returns(string[] memory)
    {
        return PledgedArray;
    }

    function getAllDonorIDs() view public returns(string[] memory)
    {
        return DonorsArray;
    }

    function getAllPatientIDs() view public returns(string[] memory)
    {
        return PatientsArray;
    }

    function getCountOfPledges() view public returns (uint)
    {
        return PledgedArray.length;
    }

    function getCountOfDonors() view public returns (uint)
    {
        return DonorsArray.length;
    }

    function getCountOfPatients() view public returns (uint)
    {
        return PatientsArray.length;
    }

}