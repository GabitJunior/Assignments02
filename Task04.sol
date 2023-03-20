// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VotingSystem {

    struct VotingSession {
        string topic;
        string[] options;
        bool isClosed;
    }

    VotingSession[] public votingSessions;
    mapping(uint256 => mapping(string => uint256)) public voteCounts;

    function createVotingSession(string memory _topic, string[] memory _options) public {
        votingSessions.push(VotingSession(_topic, _options, false));
    }

    function giveVote(uint256 _votingSessionIndex, string memory _option) public {
        require(_votingSessionIndex < votingSessions.length, "Invalid voting session index");
        require(!votingSessions[_votingSessionIndex].isClosed, "Voting session is closed");

        voteCounts[_votingSessionIndex][_option]++;
    }

    function getVoteCount(uint256 _votingSessionIndex, string memory _option) public view returns (uint256) {
        require(_votingSessionIndex < votingSessions.length, "Invalid voting session index");

        return voteCounts[_votingSessionIndex][_option];
    }

    function getVotingSessions() public view returns (VotingSession[] memory) {
        return votingSessions;
    }

    function getVotingSessionResults(uint256 _votingSessionIndex) public view returns (string[] memory, uint256[] memory) {
        require(_votingSessionIndex < votingSessions.length, "Invalid voting session index");

        uint256 optionCount = votingSessions[_votingSessionIndex].options.length;
        string[] memory options = new string[](optionCount);
        uint256[] memory voteCounts = new uint256[](optionCount);

        for (uint256 i = 0; i < optionCount; i++) {
            options[i] = votingSessions[_votingSessionIndex].options[i];
            voteCounts[i] = getVoteCount(_votingSessionIndex, options[i]);
        }

        return (options, voteCounts);
    }

    function closeVotingSession(uint256 _votingSessionIndex) public {
        require(_votingSessionIndex < votingSessions.length, "Invalid voting session index");

        votingSessions[_votingSessionIndex].isClosed = true;
    }
}
