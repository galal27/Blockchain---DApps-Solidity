{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf200
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 U.S. Presidential Election Voting Ballot - DApp\
\
Built a voting ballot for U.S. 2016 Presidential Election with 4 candidates, such that there is a chairperson who is authorized to register voters. Voters have the permission to vote only after the registration process.\
\
The smart contract used is based on the example in solidity docs.\
\
## Business Logics handled\
1. Chairperson registers accounts to vote\
2. No other account can register accounts to vote\
3. Can't register already registered user\
4. Unregistered account can't vote\
5. Registered accounts cannot vote twice\
6. Can't vote a person who is not there\
\
## Business logic to be included\
1. State change rules\
2. Save start time as a state variable\
\
## Prerequisite\
1. NodeJs\
2. Metamask (3.14.1)\
3. Truffle (v4.0.4)\
\
## Instruction for truffle testing\
1. Clone the repository to a local folder\
2. Go to the cloned folder using command line\
3. Execute truffle compile\
4. Open a new command line and execute truffle develop to start the blockchain network\
5. In the old terminal execute truffle migrate --reset\
6. Execute truffle test\
\
This should print the following in the console}