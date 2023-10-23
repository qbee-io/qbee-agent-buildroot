################################################################################
#
# embeddedinn package
#
################################################################################

QBEE_AGENT_VERSION = 2023.42
QBEE_AGENT_SOURCE = qbee-agent-$(QBEE_AGENT_VERSION).tar.gz
QBEE_AGENT_SITE = https://cdn.qbee.io/software/qbee-agent/$(QBEE_AGENT_VERSION)/binaries
QBEE_AGENT_LICENSE = Apache-2.0

ifeq ($(BR2_arm),y)
GO_GOARCH = arm
else ifeq ($(BR2_aarch64),y)
GO_GOARCH = arm64
else ifeq ($(BR2_i386),y)
GO_GOARCH = 386
else ifeq ($(BR2_x86_64),y)
GO_GOARCH = amd64
endif

define QBEE_AGENT_BUILD_CMDS
endef

define QBEE_AGENT_INSTALL_TARGET_CMDS
    $(INSTALL) -m 0755 $(@D)/qbee-agent-$(QBEE_AGENT_VERSION)/qbee-agent-$(GO_GOARCH)  $(TARGET_DIR)/usr/bin/qbee-agent
    $(INSTALL) -d -m 0700 $(TARGET_DIR)/etc/qbee/ppkeys
    $(INSTALL) -m 0600 $(@D)/qbee-agent-$(QBEE_AGENT_VERSION)/share/ssl/ca.cert  $(TARGET_DIR)/etc/qbee/ppkeys/ca.cert
endef

define QBEE_AGENT_INSTALL_INIT_SYSTEMD
    $(INSTALL) -D -m 0644 $(@D)/qbee-agent-$(QBEE_AGENT_VERSION)/init-scripts/systemd/qbee-agent.service \
        $(TARGET_DIR)/usr/lib/systemd/system/qbee-agent.service
endef

define QBEE_AGENT_INSTALL_INIT_SYSV
    $(INSTALL) -D -m 755 $(@D)/qbee-agent-$(QBEE_AGENT_VERSION)/init-scripts/sysvinit/qbee-agent \
        $(TARGET_DIR)/etc/init.d/S99qbee-agent
endef

$(eval $(generic-package))
