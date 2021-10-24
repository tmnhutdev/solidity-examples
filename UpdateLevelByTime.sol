// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract coin {
    unit public playerCount = 0;
    mapping (address => Player) public palyers;

    enum Level(Beginer, Intermediate, Advanced)

    struct Player {
        address PlayerAddress;
        Level level;
        string firstName;
        string lastName;
        unit createdTime;
    }

    function addPlayer(string memory _firstName, string memory _lastName) public {
        palyers[msg.sender] = Player(msg.sender, Level.Beginer, _firstName, _lastName, block.timestamp);
        playerCount += 1;
    }

    function getPalyerLevel(address _playerAddress) public view returns (Level) {
        return palyers[_playerAddress].level;
    }

    function updatePlayerLevel(address _playerAddress) {
        Player storage player = palyers[_playerAddress];
        if(block.timestamp >= player.createdTime + 15) {
            player.level = Level.Intermediate;
        }
    }
}