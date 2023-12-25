# Jenkins - Maven

- [Apache Maven](https://maven.apache.org/)

- [Java JDK](https://www.oracle.com/java/technologies/downloads/)

To use Java and Maven commands in the terminal for `Windows(10)`:

```
    This PC -> Properties -> Settings ->  Advanced system settings -> Environment variables -> System variables -> PATH
```

![](/pictures/EnvironmentVariables.PNG)

```cs
C:\simple-maven-project>
java -version

mvn
mvn clean
mvn compile	                                        // build
mvn exec:java -Dexec.mainClass=com.test.example.App	// çalıştırma
```

---

To use Java and Maven commands in the terminal for `Ubuntu`:

```cs
Java:
java -version

sudo apt update
sudo apt install default-jdk

sudo add-apt-repository ppa:linuxuprising/java
sudo apt update
sudo apt install oracle-java15-installer

java -version
```

```cs
Maven:

sudo apt-get install maven
mvn -v
```

---

## [Jenkins](https://www.jenkins.io/)

[Jenkins Docker Hub](https://hub.docker.com/r/jenkins/jenkins)

```cs
docker pull jenkins/jenkins:lts-jdk17
```

```cs
vscode extention - docker - image run -> http://localhost:8080/

Administrator password:
	Containers -> Files/var/jenkins_home/secrets/initialAdminPassword
		install suggested plugins
--
	Dockerfile -> Build Image...
		 	-> jenkinswithblueocean:latest
```

## [Jenkins install for Windows](https://www.jenkins.io/download)

```cs
https://www.jenkins.io/download -> Windows
	\jdk-11.0.17\	->   localhost:8080
    // java son versiyonları ile çalışmaz

password:
cat C:\ProgramData\Jenkins\.jenkins\secrets\initialAdminPassword
```

---

## SSH install for Windows

PowerShell - Administrator:

```cs
    Get-WindowsCapability -Online | Where Name -like 'OpenSSH*'
// OpenSSH... içeren modülleri görmemizi sağlar

// Aranan modül yok ise yüklenebilir =>
// State : NotPresent
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
// State : Installed

// Windows Hizmetler altında çalıştırılması gerekir
	Start-Service -name sshd	// bu şekilde de service'ler başlatılabilir
	Set-Service -name sshd -StartupType 'Automatic'	 // serviceler'i otomatik başlatır
```

![](/pictures/OpenSSH.PNG)

- Asimetrik Şifreleme ile ssh:

```cs
// ssh - public key ile bağlanmasını sağlamak için
// gizli dosya -> Görünüm - Seçenekler - Görünüm
	C:\ProgramData\ssh\sshd_config	<- Not Defteriyle
--
	#PubkeyAuthentication yes 	// Açıklamayı kaldır (#)
--
	Match Group administrators	// Deaktif yap	(# ekle)
		AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
```

```yml

---
PubkeyAuthentication yes
---
#Match Group administrators
#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
```

```bash
Key'ler için  <-  ( Git Bash ) :

ssh-keygen
	> enter -> default - publicKey = sunucu | privateKey = kullanıcı
	> publicKey = sunucu üzerinde authorized_keys.txt dosyası üzerine yazar
```

```cs
C:\Users\Excalibur\.ssh
	public key.pub.copy -> authorized_keys
	private key
	public key.pub
```

![](/pictures/authorized_keys.PNG)

---

### Jenkins Agent Setup

```bash
Credentials:
http://localhost:8080/manage/credentials/store/system/domain/_/newCredentials
Jenkins'i Yönet >> Credentials >> Stores scoped to Jenkins >> (global) >> Add Credentials

Kind:
	SSH Username with private key
	Scope:
	Global (Jenkins, nodes, items, all child items, etc)
	ID:
		win-agent-SSHKey
	Username:
		DESKTOP-R6K64T9\Excalibur
	Private Key -> Enter directly -> Key:
		id_ed25519 -> - Dosya - PRIVATE KEY
	Create
```

```bash
Nodes:
http://localhost:8080/manage/computer/
Jenkins'i Yönet >> Nodes (Sunucular ve Bulutlar) >> New Node

Node name:
	win-agent
Type:
	Permanent Agent = true

Remote root directory:
	C:\jenkins-agent
Launch method:
	Launch agents via SSH
	Host:
		localhost
	Credentials:
		DESKTOP-R6K64T9\Excalibur
	Host Key Verification Strategy:
		Non verifying Verification Strategy
		Port:
			22
	Save
```

---

### Jenkins Pipeline

```bash
http://localhost:8080/job/mvn-project/configure
Yeni Öğe >> Pipeline

Pipeline:
	Pipeline script <- Hello Word:
		pipeline {
			agent { label 'win-agent' }

			stages {
				stage('Build') {
					steps {
						bat 'rm -rf simple-maven-project'
						bat 'git clone https://github.com/mhalilmuti/simple-maven-project'
						bat 'cd simple-maven-project && mvn -DskipTests clean'
						bat 'cd simple-maven-project && mvn -DskipTests compile'
					}
				}
			}
		}
```
