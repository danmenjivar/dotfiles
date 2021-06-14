# Setting Up Git
1. Configure  
```
git config --global user.name "Your Name"
git config --global user.email "yourname@example.com"
```
2. Change master to main
```
git config --global init.defaultBranch main
```
3. Enable colorful output
```
git config --global color.ui auto
```
4. Verify config
```
git config --get user.name
git config --get user.email
```

# Link GitHub with SSH  
1. Check if you have an SSH key already 
```
$ ls ~/.ssh/id_rsa.pub
```
2. If not, generate one: 
```
$ ssh-keygen -C <youremail>
```
3. In GitHub under `Settings` > `SSH and GPG keys` > `New SSH Key` enter your public SSH key `$ cat ~/.ssh/id_rsa.pub`
4. Test your ssh key 
```
$ ssh -T git@github.com
```
