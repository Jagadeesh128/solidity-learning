// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Twitter {
    
    uint16 public MAX_TWEET_LENGTH = 280;

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[] ) public tweets;
    address public owner;

    //Events 
    event TweetCreated(uint256 indexed  id, address indexed author, string content, uint256 timestamp);
    event TweetLiked(address indexed liker, address indexed tweetAuthor, uint256 indexed tweetId, uint256 newLikeCount);
    event TweetUnliked(address indexed unliker, address indexed tweetAuthor, uint256 indexed tweetId, uint256 newlikeCount);

    constructor() {
        owner= msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"You are not Owner");
        _;
    }

    function createTweet(string memory _tweet) public {

        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long!" );

        Tweet memory newTweet = Tweet( {
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);
        
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet Does Not Exist");
        tweets[author][id].likes++;

        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet Does Not Exist");
        require(tweets[author][id].likes > 0, "Tweet Has No Likes");
        tweets[author][id].likes--;

        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

    function getTweet(uint _i) public view returns(Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns(Tweet[] memory) {
        return tweets[_owner];
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }
}