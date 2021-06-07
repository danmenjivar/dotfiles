# How to Link GitHub with SSH

1. Check if you have an SSH key already `$ ls ~/.ssh/id_rsa.pub`
2. If not, generate one: `$ ssh-keygen -C <youremail>`
3. In GitHub under `Settings` > `SSH and GPG keys` > `New SSH Key` enter your public SSH key `$ cat ~/.ssh/id_rsa.pub`
4. Test your key `$ ssh -T git@github.com`