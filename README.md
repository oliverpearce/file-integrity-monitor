# file-integrity-monitor

a file integrity monitor (FIM) is an application that checks file integrity, which is a cornerstone of the CIA triad of confidentiality, **integrity**, and availability

this application is merely a proof-of-concept, but can easily be expanded upon!

# how does it work?

essentially, we continuously monitor file integrity by checking files against a baseline

![fim diagram](./fim%20diagram.png)

the **hash** allows us to continually check for changes, as if the hash changes then there must be a change in the original file