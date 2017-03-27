// 'module.exports' is a node.JS specific feature, it does not work with regular JavaScript
module.exports =
{
  isAccountLocked: function (web3, account)
  {
    try {
        web3.eth.sendTransaction({
            from: account,
            to: account,
            value: 0
        });
        return false;
    } catch (err) {
        return (err.message == "authentication needed: password or unlock");
    }
  },

  unlockAccountsIfNeeded: function (web3, accounts, password)
  {
    for (var i = 0; i < accounts.length; i++) {
        if (this.isAccountLocked(web3, accounts[i])) {
            console.log("Account " + accounts[i] + " is locked. Unlocking")
            web3.personal.unlockAccount(accounts[i], password, 0);
        }
    }
  }
};
