#!/data/data/com.termux/files/usr/bin/bash
# Kill a hung gpg-agent and re-test symmetric encryption (run as a file so pkill does not match this shell).
for p in $(pgrep -f 'gpg-agent') $(pgrep -f 'gpg-connect-agent') $(pgrep -x gpg) $(pgrep -x gpgconf); do kill -9 "$p" 2>/dev/null; done
sleep 1
rm -f ~/.gnupg/.#lk* ~/.gnupg/*.lock ~/.gnupg/S.gpg-agent* 2>/dev/null
echo "locks cleared"
echo test | timeout 20 gpg --batch --quiet --lock-never --pinentry-mode loopback --passphrase-file ~/.config/studio/vault.pass --symmetric --cipher-algo AES256 --yes -o "$PREFIX/tmp/t.gpg"
echo "gpg rc=$?"
ls -la "$PREFIX/tmp/t.gpg" 2>/dev/null
rm -f "$PREFIX/tmp/t.gpg"
pgrep -fa 'gpg-agent' | cut -c1-80
