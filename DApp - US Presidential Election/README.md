U.S. Presidential Election Voting Ballot - DApp

Built a voting ballot for U.S. 2016 Presidential Election with 4 candidates, such that there is a chairperson who is authorized to register voters. Voters have the permission to vote only after the registration process.

The smart contract used is based on the example in solidity docs.

## Logic
1. Chairperson registers accounts to vote
2. No other account can register accounts to vote
3. Can't register already registered user
4. Unregistered account can't vote
5. Registered accounts cannot vote twice
6. Can't vote a person who is not there
