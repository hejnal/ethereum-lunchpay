Welcome to LunchPay!
===================


This is a example project using Solidity contracts to represent the basic real life use case. The idea is illustrate the following concepts

 - Name registry
 - Inheritance
 - Tokens to represent assets or financial value
 - Events
 - Structs, mappings and arrays
 - Interaction between contracts (with ABI and without it)

Use Case
-------------

 Imagine a group of people, friends or team members, that usually eat together in the restaurant and want to optimize the payments to be done by one of them at the time. This is common way in many countries, of even splitting the bill between all diners. It makes easier and faster for the waiter or waitress and the group of people. By implementing a Smart Contract the group decides to store the list of balances in the chain of immutable blocks.

> **Note:**

> The project is only experimental and does not pretend to cover all cases and possible complex validations, like group evolution, transferring debts from one to another, changing groups etc.

#### <i class="icon-file"></i> Basic Assumptions

The basic structure of contracts and structures involves:

 1. Project
 2. Group
 3. LunchPay
 4. NameReg
 5. Person

Each **Project** contract has its manager who adds members to the list of global members and creates new **LunchPay** contracts which inherits from **Group** contract that automatically are registered in the **NameReg** by name, to be easily looked up later.

- One person can be part of different teams which are **LunchPay** contracts

- Two basic operations that a **Person** can do with the **LunchPay** contract are: *consultNextPayer* and *pay*

- The list of balances are stored in the **Project** contract and are constant does not require sending a new transaction


#### <i class="icon-folder-open"></i> Basic Example

Imagine we have 4 Persons: *Alice*, *Bob*, *Mike* and *Susan* that are assigned to two different teams, *GoodFellas* and *BlueOcean*.

We need to store their balances as the following:

1) initial state:
Name     | Value
-------- | ---
Alice	 | 0
Bob      | 0
Mike     | 0
Susan    | 0

System suggest that Alice should pay for the next lunch [Alice, Bob, Mike]:

2) Alice pays for herself, Bob and Mike
Name     | Value
-------- | ---
Alice	 | 2
Bob      | -1
Mike     | -1
Susan    | 0

System suggest that Bob should pay for the next lunch [Bob, Alice]:

3) Bob pays for himself and Alice
Name     | Value
-------- | ---
Alice	 | 1
Bob      | 0
Mike     | -1
Susan    | 0

> **Tip:** In every moment, the sum of all balances should be 0, there is no need of moving a real money in this system, the idea is to always end up with no debts..

Installation
-------------------

Most of the operations have been automated, including the blockchain single node creation and basic setup and operations to send some ethers or to unlock accounts.

There are some basic dependencies that can be installed manually or a vagrant image with the provisioning script can be used instead.

Dependencies:
```
npm install node-menu
npm install web3
```

Vagrantfile:
```
config.vm.box = "ubuntu/trusty64"
    config.vm.provision :shell, :path => "provision/setup.sh"
    config.vm.network :forwarded_port, host: 8545, guest: 8545
    config.ssh.insert_key = true
    config.vm.synced_folder "sh", "/home/vagrant/sh"
    config.vm.synced_folder "contracts", "/home/vagrant/contracts"
    config.vm.synced_folder "js", "/home/vagrant/js"
```


Simply run:
```
vagrant up
```

Ethereum private chain setup:

```
sh/create-private-chain.sh
sh/start-private-chain.sh
```

Check the chain status:
```
sh/check_the_status.sh
```

Testing
-------------------
A very simple javascript menu console has been implemented to play around with the contract. It allows the basic setup and some simple operations to be run.

To run the console, simply run:
```
sh/start-contract-admin-menu.sh
```
> **Note:** Currently there is no full support for the Event filtering and subscription, use the wallet software to view more data in the event log.

The console shows the following options:

--------------------------------Contract Deploy--------------------------------

1. Unlock all accounts
2. Deploy Name Registry Contract
3. Deploy Project Contract
4. Watch Name Registry Contract at specific address
5. Watch Project Contract at specific address
6. Print details of NameReg contract
7. Print details of Project contract

---------------------------------Initial Setup---------------------------------

8. Add 4 members to the Project [Alice, Bob, Mike, Suzan]
9. Add 2 new PayLunch Contracts [GoodFellas, BlueOcean]
10. Assign persons to new PayLunch contracts    [(Alice, Bob, Mike) -> GoodFellas, (Mike,Suzan) -> BlueOcean]

-----------------------------LunchPay Interactions-----------------------------

11. Share 1 ether with the rest of accounts from the Ether Base account (to be able to do transactions)
12. Pay for Lunch in the GoodFellas LunchPay Group [GoodFellas]
13. Pay for Lunch in the BlueOcean LunchPay Group [BlueOcean]

-------------------------------LunchPay Queries--------------------------------

14. Print the current balances for all members of the Project
15. Print the current balances for GoodFellas
16. Print the current balances for BlueOcean

All items showned in bold should be executed in order to see a basic execution.

> **Note:** If you have stored the address of the previously created contracts, you can easily watch them, by only providing its address.

### Support StackEdit

[![](https://cdn.monetizejs.com/resources/button-32.png)](https://monetizejs.com/authorize?client_id=ESTHdCYOi18iLhhO&summary=true)

  [^stackedit]: [StackEdit](https://stackedit.io/) is a full-featured, open-source Markdown editor based on PageDown, the Markdown library used by Stack Overflow and the other Stack Exchange sites.
