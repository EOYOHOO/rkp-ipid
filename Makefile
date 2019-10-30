include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
 
PKG_NAME:=rkp-ipid
PKG_RELEASE:=1
 
include $(INCLUDE_DIR)/package.mk

EXTRA_CFLAGS:= \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=m,%,$(filter %=m,$(EXTRA_KCONFIG)))) \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=y,%,$(filter %=y,$(EXTRA_KCONFIG)))) \
	-DVERSION=$(PKG_RELEASE) -Wcpp

MAKE_OPTS:=$(KERNEL_MAKE_FLAGS) \
	SUBDIRS="$(PKG_BUILD_DIR)" \
	EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
	CONFIG_RKP_IPID=m

define KernelPackage/rkp-ipid
	SUBMENU:=Other modules
	TITLE:=rkp-ipid
	FILES:=$(PKG_BUILD_DIR)/rkp-ipid.ko
	AUTOLOAD:=$(call AutoLoad, 99, rkp-ipid)
	KCONFIG:=
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" $(MAKE_OPTS) modules
endef

$(eval $(call KernelPackage,rkp-ipid))