Date: 2025-04-16
---

**Note:** Be disciplined in what data you move from Atlas! If you're not the data owner, ensure you have permissions.  If the data is >100mb it should probably go somewhere other than GitHub (i.e., codebase vs. database).


# How to connect Atlas and GitHub

## Basic Steps
  
1. Create keypair on the HPC 
2. Authorize the HPC **public** key with GitHub 
3. Configure Git on the cluster to use that key 
4. Clone, commit, and push as usual
---

### 1. Generate an SSH keypair on the HPC

Open Atlas Shell Access  
	Go to your individual account home directory
```
cd /home/first.last
```

**Run:**
```
ssh-keygen -t ed25519 -C "your.email@institution.edu"  (~/.ssh/id_ed25519)
```
(Enter a passphrase, if desired)

This produces:
>`~/.ssh/id_ed25519`      (private key)

>`~/.ssh/id_ed25519.pub` (public key)


### 2. Copy the public key to GitHub

1. Copy the the contents in  `~/.ssh/id_ed25519.pub` (passkey code)
    
2. Go to **GitHub** → **Settings** → **SSH and GPG keys** → **New SSH key**
    
3. Paste the copied key (all of it, not just the numbers) into the open field, then give it a name (e.g. “Atlas HPC”), and **Save**.
    
**Note:** Private keys should stay in a secure environment (Atlas) the public ones can be shared with other apps.  GitHub public servers are not all in the U.S., but the enterprise ones are in the U.S.

---

### 3. Test SSH connectivity

Ensure git is running:
```
module load git
```
On the cluster, run:
```
ssh -T git@github.com
```

You should see:
> `Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.`

---

### 4. Get your Git together

1. **Clone via SSH** (replace with your repo URL):
    ```
    git clone git@github.com:your‑org/your‑repo.git
    ```
2.  **Commit and push** as usual:
```
git add . 
git commit -m "My commit message"
git push origin main
```

It should authenticate automatically
