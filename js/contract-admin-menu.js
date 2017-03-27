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
      this.projectContract.addMember(web3.eth.accounts[0] ,"Alice", {
          from: web3.eth.accounts[0],
          gas: 1000000
      });

      this.projectContract.addMember(web3.eth.accounts[1] ,"Bob", {
          from: web3.eth.accounts[0],
          gas: 1000000
      });

      this.projectContract.addMember(web3.eth.accounts[2] ,"Mike", {
          from: web3.eth.accounts[0],
          gas: 1000000
      });

      this.projectContract.addMember(web3.eth.accounts[3] ,"Suzan", {
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



var myContracts = new MyContracts();

menu.addDelimiter('-', 80, 'Contract Deploy')
    .addItem(
    'Unlock all accounts',
    function() {
        utils.unlockAccountsIfNeeded(web3, web3.eth.accounts,"test");
    })
    .addItem(
        'Deploy Name Registry Contract [NameReg]',
        function() {
            deploy.deployNameReg(web3, function(contract){
                    myContracts.nameRegContract = contract;
            });
        })
    .addItem(
        "Deploy Project Contract [Project] ",
        function() {
            if (typeof myContracts.nameRegContract == 'undefined') {
                console.log("First you need to deploy the NameReg contract.");
            } else {
                    deploy.deployProject(web3, myContracts.nameRegContract.address, function(contract){
                    myContracts.projectContract = contract;
                  });
            }
        })
    .addItem(
        'Print details of NameReg contract',
        myContracts.printRegContract,
        myContracts)
    .addItem(
        'Print details of Project contract',
        myContracts.printProjectContract,
        myContracts)
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
    .addDelimiter('-', 80, 'LunchPay Interactions')
    .addItem(
        'Print the current balances for Goodfellas]',
        function() {
            var goodFellas = web3.eth.contract(deploy.getLunchPayABI()).at(myContracts.nameRegContract.addressOf(myContracts.projectContract.lunchPayContracts(0)));
            console.log(goodFellas);
        })
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
