;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; sudo cryptsetup luksFormat --hash=sha512 -c aes-xts-plain64 --key-size=512 -y -v --type luks /dev/nvme0n1
;; sudo cryptsetup open --type luks /dev/nvme0n1 my-partition
;; mkfs.ext4 -L my-home /dev/mapper/my-partition
;;
;; guix pull
;; sudo guix system reconfigure /etc/config.scm
;;
(use-modules (gnu) 
             (gnu services)
             (gnu packages cups)
             (gnu services docker)
             (gnu services auditd)
             (gnu system locale)
             (nongnu packages linux)
             (nongnu system linux-initrd)
            )
(use-service-modules desktop networking ssh xorg cups docker auditd  nix ) ; nix
(use-package-modules package-management) ; TEST
;;
;;;; NONFREE
;(use-modules (nongnu packages linux)
;             (nongnu system linux-initrd))
;
;(operating-system
;  (kernel linux)
;  (initrd microcode-initrd)
;  (firmware (list linux-firmware))
;  ...
;  )
;;;;
;;
(operating-system
  (locale "sv_SE.utf8")
  ;
  ;(locale-definitions
  ;  (append 
  ;    (list (locale-definition (name "sv_SE.utf8") (source "sv_SE") (charset "UTF-8") )
  ;          (locale-definition (name "en_US.utf8") (source "en_US") (charset "UTF-8") )
  ;          (locale-definition (name "zh_CN.utf8") (source "zh_CN") (charset "UTF-8") )
  ;    )
  ;  )
  ;)
  (timezone "Europe/Stockholm")
  (keyboard-layout (keyboard-layout "se"))
  (host-name "specter")
  (kernel linux)                    ; NONFREE
  (initrd microcode-initrd)         ; NONFREE
  (firmware (list linux-firmware))  ; NONFREE
  (users (cons* (user-account
                  (name "rictjo")
                  (comment "Richard Tjörnhammar")
                  (group "users")
                  (home-directory "/home/rictjo")
                  (supplementary-groups
                   '("wheel" "netdev" "audio" "video"
		     "lp" "disk" "scanner" "nixbld") )) ; "kvm"
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "i3-wm")
            (specification->package "i3status")
            (specification->package "i3blocks")
            (specification->package "dmenu")
            (specification->package "st")
            (specification->package "nss-certs")
	    (specification->package "cups")
	    (specification->package "hplip")
            (specification->package "util-linux")
	    (specification->package "ghostscript") ;)
            nix ) ; TESTING
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (service tor-service-type)
            (service nix-service-type) ; TESTING
            (service docker-service-type)
            (service auditd-service-type)
            (service cups-service-type
              (cups-configuration 
                (web-interface? #t) ; ))
                (extensions
                  (list cups-filters hplip)) ))
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout)
                ; (drivers '("xf86-video-amdgpu" "modesetting" "vesa" ) )
              )
            )
      )
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
      (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
            (source
              (uuid "55cab081-dd9b-4307-abed-6266c7b2694f"))
            (target "cryptroot")
            (type luks-device-mapping))
	  (mapped-device
	   (source (uuid "5a7496d4-d93c-4234-a859-ee2ce5a4db58"))
	   (target "my-home")
	   (type luks-device-mapping))
	  ))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "8F7E-CEEF" 'fat32))
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
