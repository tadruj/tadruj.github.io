// questionmark will match the shortest, instead of the broadest(default) string
"This is cool, very cool thing".match(/.*cool/)
// ["this is cool, very cool"]
"this is cool, very cool thing".match(/.*?cool/)
// ["this is cool"]

