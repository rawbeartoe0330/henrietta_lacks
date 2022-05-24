const PatientList = artifacts.require("PatientList");

module.exports = function (deployer) {
  deployer.deploy(PatientList);
};
