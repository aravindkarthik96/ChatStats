class MessageEmojiCountStats{
  List<MessageEmojiCount> topEmojisList;
  int totalEmojisUsed;
  MessageEmojiCountStats(this.topEmojisList, this.totalEmojisUsed);
}

class MessageEmojiCount {
  String emoji;
  int emojiCount;
  MessageEmojiCount(this.emoji, this.emojiCount);
}