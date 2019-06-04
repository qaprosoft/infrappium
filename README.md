## Ansible repository to setup infrastructure of running Appium tests on Android

File `hosts` contains server addresses to setup

File `defaults/main.yml` contains main Ansible tasks

#### Main tasks:
 *  appium - install shared appium with all required components
 *  devices - setup server to which real devices will be connected
 *  docker - install docker components
 *  emulators - setup server to work with emulators
 *  grid-router - setup selenium-hub

#### Main playbooks:
 *  emulators.yml - setup server(s) to work with emulators
 *  devices.yml - setup server(s) to work with real devices
 *  router.yml - setup selenium-hub for devices

#### Example of the setup server to work with emulators:
`ansible-playbook -vvv -i hosts --user=ubuntu --extra-vars "ansible_sudo_pass=<pswd>" emulators.yml`
`ansible-playbook -vvv -i hosts --user=ubuntu --extra-vars "ansible_sudo_pass=<pswd>" devices.yml`
