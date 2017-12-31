const EndorCrowdsale = artifacts.require("EndorCrowdsale");
const EndorToken = artifacts.require("EndorToken");

module.exports = function(deployer, network, accounts) {
    const startTime = new Date().getTime() / 1000 + 120;
    const endTime = startTime + 600;
    deployer
        .deploy(EndorCrowdsale, startTime, endTime, 2, accounts[0], 5 * Math.pow(10, 18));
};
