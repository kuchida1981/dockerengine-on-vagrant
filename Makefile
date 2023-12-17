INSTALL_DIR := ${HOME}/.local
SYSTEMD_UNIT_DIR := ${HOME}/.config/systemd/user

install: Vagrantfile service default.conf
	install -Dm644 Vagrantfile ${INSTALL_DIR}/share/vboxdocker/Vagrantfile
	install -Dm644 default.conf ${INSTALL_DIR}/share/vboxdocker/default.conf
	install -Dm644 service ${SYSTEMD_UNIT_DIR}/vboxdocker@.service
