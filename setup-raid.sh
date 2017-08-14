#!/bin/bash
echo "This will delete /dev/sda - /dev/sdd and make a raid"
read x

for disk in `ls /dev/sd[a-d]`; do
echo "mklabel gpt
mkpart primary 1MiB 100%
set 1 raid on
quit
" | parted ${disk}
done

mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/sd[a-d]1
cryptsetup luksFormat /dev/md0
cryptsetup luksOpen /dev/md0 md0_crypt
mkfs.xfs /dev/mapper/md0_crypt
md0_block_id=`blkid | grep /dev/md0 | awk '{print $2}' | sed 's/"//' | sed 's/"//'`
dd if=/dev/urandom of=/etc/cryptkey-md0 bs=512 count=4
cryptsetup luksAddKey /dev/md0 /etc/cryptkey-md0
echo "md0_crypt ${md0_block_id} /etc/cryptkey-md0" >> /etc/crypttab
mkdir /mnt/vault
echo "/dev/mapper/md0_crypt /mnt/vault xfs rw,relatime,attr2,inode64,noquota 0 2" >> /etc/fstab
