// SPDX-License-Identifier: MIT 
pragma solidity >= 0.7.0<0.9.0;

// making a voting contract

// 1. We want the ability to accept proposals and store them.
// proposal: their name, number


// 2. voters & voting ability
// keep track of voting
// check voters are authenticated to vote


// 3. chairperson
// authenticate and deploy contract


contract Ballot{
    // struct is a method to create your own data type

    // voters: voted = bool, access to vote = uint, vote index = uint

    struct Voter {
        uint vote;
        bool voted;
        uint weight;
    }

    struct Proposal{
        bytes32 name;  //name of each proposal
        uint voteCount; // number of accumulated votes
    }

    Proposal[] public proposals;

    mapping(address => Voter) public voters; // voters get address as the key and Voter as the value

    address public chairperson;



    constructor(bytes32[] memory proposalNames ) {
        // memory defines a temporary data location in Solidity
        // we guarantee space for it
        
        chairperson = msg.sender;
        
        voters[chairperson].weight = 1;

        // msg.sender is a global variable that states the person
        // who is currently connecting to the contract

        // will add the proposal names to the smart contract upon deployment
        for (uint i=0; i<proposalNames.length; i++)
        {
            proposals.push(Proposal({
                name : proposalNames[i],
                voteCount : 0
            }));
        }
    }

    // function to authenticate voter
    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
                'Only the chairperson can give access to vote'
        );
        require(!voters[voter].voted,
                'The voter has already voted'
        );

        require(voters[voter].weight == 0);

        voters[voter].weight = 1;
    }

    // function for voting

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight!=0, 'Has no right to vote');
        require(!sender.voted, 'Already voted');
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount = proposals[proposal].voteCount + sender.weight;
    }

    // function for showing results

    // 1. function that shows winning proposal by integer
    
    function winningProposal() public view returns (uint winningProposal_){
        uint winningVoteCount = 0;
        for (uint i=0; i<proposals.length; i++)
        {
            if(proposals[i].voteCount > winningVoteCount){
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }
    // 2. function that shows winner by name
    function winningName() public view returns (bytes32 winningName_){
        winningName_ = proposals[winningProposal()].name;
    }

}

