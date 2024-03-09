const KidneyDonorRegistry = artifacts.require("KidneyDonorRegistry");

module.exports = function(deployer) {
  deployer.deploy(KidneyDonorRegistry);
};
