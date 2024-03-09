// contracts/Transaction.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KidneyDonorRegistry {
    struct Donor {
        uint id;
        uint donorId;
        uint hospitalId;
        uint dateOfTransplant;
        uint doctorId;
        uint donorType;
    }

    mapping(uint => Donor) public donors;

    function addDonor(
        uint _id,
        uint _donorId,
        uint _hospitalId,
        uint _dateOfTransplant,
        uint _doctorId,
        uint _donorType
    ) public {
        require(donors[_id].id == 0, "Record with the same ID already exists");

        donors[_id] = Donor({
            id: _id,
            donorId: _donorId,
            hospitalId: _hospitalId,
            dateOfTransplant: _dateOfTransplant,
            doctorId: _doctorId,
            donorType: _donorType
        });
    }
}