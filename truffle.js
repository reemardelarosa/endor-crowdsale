module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "5777" // Match any network id
        },
        rinkeby: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "4", // Match any network id
            from: "0x6F02fD0F104a9f9EE7FDeEd021655D83dbdEBA7c",
            gas: 6000000
        }
    }
};
