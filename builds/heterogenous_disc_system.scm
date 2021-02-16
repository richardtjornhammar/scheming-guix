;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; sudo cryptsetup luksFormat --hash=sha512 -c aes-xts-plain64 --key-size=NUM -y -v --type luks /dev/DISCXXX
;; sudo cryptsetup open --type luks /dev/DISCXXX my-partition
;; mkfs.ext4 -L my-home /dev/mapper/my-partition
;;
;; guix pull
;; sudo guix system reconfigure /etc/config.scm
;;
(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "sv_SE.utf8")
  (timezone "Europe/Stockholm")
  (keyboard-layout (keyboard-layout "se"))
  (host-name "saigataurus")
  (users (cons* (user-account
                  (name "rictjo")
                  (comment "Richard Tjörnhammar")
                  (group "users")
                  (home-directory "/home/rictjo")
                  (supplementary-groups
                   '("wheel" "netdev" "audio" "video"
		     "lp" "disk" "scanner") ))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "i3-wm")
            (specification->package "i3status")
            (specification->package "dmenu")
            (specification->package "st")
            (specification->package "nss-certs")
	    (specification->package "cups")
	    (specification->package "hplip")
	    (specification->package "ghostscript"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (service tor-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
      (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
            (source 
              (uuid "123aaaaa-12bv-1231-12sw-12313asdasd1" ))
            (target "cryptroot")
            (type luks-device-mapping))
	  (mapped-device
	   (source (uuid "123bbbb-12bv123112sw-12313asdasd1" ))
	   (target "my-home")
	   (type luks-device-mapping))
	  ))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "123A-ASD1" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device "/dev/mapper/cryptroot")
             (type "ext4")
             (dependencies mapped-devices))
           (file-system
             (mount-point "/home")
             (device (file-system-label "my-home"))
             (type "ext4")
	     (dependencies mapped-devices))
	   %base-file-systems))

  (initrd-modules (cons "dm_crypt"    ;needed to find the disk
                        %base-initrd-modules))
  )
