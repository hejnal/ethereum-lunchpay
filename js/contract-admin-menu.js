var menu = require('node-menu');
var deploy = require('./deploy-scripts.js');
var utils = require('./web3-utils.js')

var Web3 = require('web3');
var web3 = new Web3();

web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));

var MyContracts = function() {
    var self = this;
    self.nameRegContract;
    self.projectContract;
}

MyContracts.prototype.printRegContract = function() {
    console.log(this.nameRegContract);
}

MyContracts.prototype.printProjectContract = function() {
    console.log(this.projectContract);
}

MyContracts.prototype.addProjectMembers = function() {
    this.projectContract.addMember(web3.eth.accounts[0], "Alice", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });

    this.projectContract.addMember(web3.eth.accounts[1], "Bob", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });

    this.projectContract.addMember(web3.eth.accounts[2], "Mike", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });

    this.projectContract.addMember(web3.eth.accounts[3], "Suzan", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });
}

MyContracts.prototype.addLunchPayContracts = function() {
    this.projectContract.createLunchPay("GoodFellas", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });

    this.projectContract.createLunchPay("BlueOcean", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });
}

MyContracts.prototype.assignMembersToLunchPays = function() {
    this.projectContract.assignMemberToLunchPay("Bob", "GoodFellas", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });

    this.projectContract.assignMemberToLunchPay("Alice", "GoodFellas", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });

    this.projectContract.assignMemberToLunchPay("Mike", "GoodFellas", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });

    this.projectContract.assignMemberToLunchPay("Mike", "BlueOcean", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });

    this.projectContract.assignMemberToLunchPay("Suzan", "BlueOcean", {
        from: web3.eth.accounts[0],
        gas: 1000000
    });
}

MyContracts.prototype.printAllProjectMembersBalances = function() {
    var count = JSON.parse(this.projectContract.membersCount())
    for (var i = 0; i < count; i++) {
        var name = this.projectContract.members(i)[1];
        var balance = JSON.parse(this.projectContract.members(i)[2]);
        console.log(i + ") " + name + "=" + balance);
    }

}


var myContracts = new MyContracts();

menu.addDelimiter('-', 80, 'Contract Deploy')
    .addItem(
        'Unlock all accounts',
        function() {
            utils.unlockAccountsIfNeeded(web3, web3.eth.accounts, "test");
        })
    .addItem(
        'Deploy Name Registry Contract [NameReg]',
        function() {
            deploy.deployNameReg(web3, function(contract) {
                myContracts.nameRegContract = contract;
            });
        })
    .addItem(
        "Deploy Project Contract [Project] ",
        function() {
            if (typeof myContracts.nameRegContract == 'undefined') {
                console.log("First you need to deploy the NameReg contract.");
            } else {
                deploy.deployProject(web3, myContracts.nameRegContract.address, function(contract) {
                    myContracts.projectContract = contract;
                });
            }
        })
    .addItem(
        "Watch Name Registry Contract at specific address (add as an argument after the option number and space) [NameReg]\n" +
        "   Example: 4 '0xc738FA7bA9aC27D50D036aF1cB6eA3B02cB6616D'",
        function(addr) {
            var addrParsed = addr.replace(/\'/g, '');
            myContracts.nameRegContract = web3.eth.contract(deploy.getNameRegABI()).at(addrParsed);
        }, null, [{
            'name': 'addr',
            'type': 'string'
        }])
    .addItem(
        "Watch Project Contract at specific address (add as an argument after the option number and space) [Project]\n" +
        "   Example: 5 '0x21E14751E7553fA4A7464C14b2069fB8F4D86B67'",
        function(addr) {
            var addrParsed = addr.replace(/\'/g, '');
            myContracts.projectContract = web3.eth.contract(deploy.getProjectABI()).at(addrParsed);
        }, null, [{
            'name': 'addr',
            'type': 'string'
        }])
    .addItem(
        'Print details of NameReg contract',
        myContracts.printRegContract,
        myContracts)
    .addItem(
        'Print details of Project contract',
        myContracts.printProjectContract,
        myContracts)
    .addDelimiter(' ', 80, '')
    .addDelimiter('-', 80, 'Initial Setup')
    .addItem(
        'Add 4 members to the Project [Alice, Bob, Mike, Suzan]',
        myContracts.addProjectMembers,
        myContracts)
    .addItem(
        'Add 2 new PayLunch Contracts [GoodFellas, BlueOcean] \n   (wait before the next option)',
        myContracts.addLunchPayContracts,
        myContracts)
    .addItem(
        'Assign persons to new PayLunch contracts \n   [(Alice, Bob, Mike) -> GoodFellas, (Mike,Suzan) -> BlueOcean]',
        myContracts.assignMembersToLunchPays,
        myContracts)
    .addDelimiter(' ', 80, '')
    .addDelimiter('-', 80, 'LunchPay Interactions')
    .addItem(
        'Share 1 ether with the rest of accounts from the Ether Base account (for be able to do transactions)',
        function() {
            web3.eth.sendTransaction({
                from: web3.eth.accounts[0],
                to: web3.eth.accounts[1],
                value: web3.toWei(1, "ether")
            });
            web3.eth.sendTransaction({
                from: web3.eth.accounts[0],
                to: web3.eth.accounts[2],
                value: web3.toWei(1, "ether")
            });
            web3.eth.sendTransaction({
                from: web3.eth.accounts[0],
                to: web3.eth.accounts[3],
                value: web3.toWei(1, "ether")
            });
        })
    .addItem(
        'Pay for Lunch in the GoodFellas LunchPay Group [GoodFellas]\n' +
        '    Example: 12 1 "[0,1,2]"  ',
        function(whoPays, dinersArray) {
            var payLunchName = myContracts.projectContract.lunchPayContracts(0);
            var payLunchAddress = myContracts.nameRegContract.addressOf(payLunchName);
            var goodFellas = web3.eth.contract(deploy.getLunchPayABI()).at(payLunchAddress);

            goodFellas.pay(JSON.parse(dinersArray), {
                from: myContracts.projectContract.members(whoPays)[0],
                gas: 1000000
            });
        }, null, [{
            'name': 'whoPays',
            'type': 'numeric'
        }, {
            'name': 'dinersArray',
            'type': 'string'
        }])
    .addItem(
        'Pay for Lunch in the BlueOcean LunchPay Group [BlueOcean]\n' +
        '    Example: 13 2 "[2,3]"  ',
        function(whoPays, dinersArray) {
            var payLunchName = myContracts.projectContract.lunchPayContracts(1);
            var payLunchAddress = myContracts.nameRegContract.addressOf(payLunchName);
            var goodFellas = web3.eth.contract(deploy.getLunchPayABI()).at(payLunchAddress);

            goodFellas.pay(JSON.parse(dinersArray), {
                from: myContracts.projectContract.members(whoPays)[0],
                gas: 1000000
            });
        }, null, [{
            'name': 'whoPays',
            'type': 'numeric'
        }, {
            'name': 'dinersArray',
            'type': 'string'
        }])
    .addDelimiter(' ', 80, '')
    .addDelimiter('-', 80, 'LunchPay Queries')
    .addItem(
        'Print the current balances for all members of the Project',
        myContracts.printAllProjectMembersBalances, myContracts)
    .addItem(
        'Print the current balances for GoodFellas',
        function() {
            var payLunchName = myContracts.projectContract.lunchPayContracts(0);
            var payLunchAddress = myContracts.nameRegContract.addressOf(payLunchName);
            var goodFellas = web3.eth.contract(deploy.getLunchPayABI()).at(payLunchAddress);

            var count = JSON.parse(goodFellas.membersCount())
            for (var i = 0; i < count; i++) {
                var index = goodFellas.members(i);
                var name = myContracts.projectContract.members(goodFellas.members(i))[1];
                var balance = JSON.parse(myContracts.projectContract.members(goodFellas.members(i))[2]);
                console.log(index + ") " + name + "=" + balance);
            }
        })
    .addItem(
        'Print the current balances for BlueOcean',
        function() {
            var payLunchName = myContracts.projectContract.lunchPayContracts(1);
            var payLunchAddress = myContracts.nameRegContract.addressOf(payLunchName);
            var blueOcean = web3.eth.contract(deploy.getLunchPayABI()).at(payLunchAddress);

            var count = JSON.parse(blueOcean.membersCount())
            for (var i = 0; i < count; i++) {
                var index = blueOcean.members(i);
                var name = myContracts.projectContract.members(blueOcean.members(i))[1];
                var balance = JSON.parse(myContracts.projectContract.members(blueOcean.members(i))[2]);
                console.log(index + ") " + name + "=" + balance);
            }
        })
    .addDelimiter(' ', 80)
    .addDelimiter('*', 80)
    .customHeader(function() {
        process.stdout.write("Welcome to the LunchPay contract menu\n\n");
    })
    .disableDefaultHeader()
    .customPrompt(function() {
        process.stdout.write("\nEnter your selection:\n");
    })
    .disableDefaultPrompt()
    .start();
