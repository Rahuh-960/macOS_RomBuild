# creating a filesystem of 220GB
sudo hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 220g ~/android.dmg.sparseimage
sudo hdiutil attach ~/android.dmg.sparseimage -mountpoint /Volumes/android

su - runner

rm -f /Applications/Xcode.app 2>/dev/null
# If Xcode 12.3 is not available in /Applications/, use the latest one and replace the addresses
sudo xcode-select -s /Applications/Xcode_12.3.app/Contents/Developer
ln -s /Applications/Xcode_12.3.app /Applications/Xcode.app



cd /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs
for i in 10 11 12 13 14 15; do
  aria2c -x16 -s16 https://github.com/phracker/MacOSX-SDKs/releases/download/10.15/MacOSX10.$i.sdk.tar.xz
  tar xJf MacOSX10.$i.sdk.tar.xz
  rm -f MacOSX10.$i.sdk.tar.xz
done


brew install openjdk@8
sudo ln -sfn /usr/local/opt/openjdk@8/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk
export PATH="/usr/local/opt/openjdk@8/bin:$PATH"
# We are setting 12 gigabytes of ram for java heap
export JAVA_OPTS=" -Xmx12G "



# macOS-11 has make 3.81 installed, but we want to use latest one by building it
mkdir -p ~/bin 2>/dev/null
wget -q https://ftp.gnu.org/gnu/make/make-4.3.tar.gz
tar xzf make-4.3.tar.gz && cd make-*/
./configure && bash ./build.sh &>/dev/null && install ./make ~/bin/make
cd .. && rm -rf make-*
export PATH="~/bin:$PATH"


brew install ccache
export PATH="/usr/local/opt/ccache/libexec:$PATH"

# Change Directory to android volume
cd /Volumes/android

# Download repo binary
mkdir -p ~/bin 2>/dev/null
export PATH="~/bin:/usr/local/bin:$PATH"
curl -sL https://storage.googleapis.com/git-repo-downloads/repo -o ~/bin/repo
chmod a+x ~/bin/repo

git config --global color.ui true




