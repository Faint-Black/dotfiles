;;============================================================================;;
;;                                                                            ;;
;;              My personal server-oriented GuixSD config file.               ;;
;;                                                                            ;;
;;============================================================================;;

;;----------------------------------------------------------------------------;;
;; Variable definitions for this scheme file.                                 ;;
;;----------------------------------------------------------------------------;;
(use-modules (gnu)
             (gnu services)
             (gnu packages linux)
             (gnu packages web)
             (gnu packages admin)
             (gnu packages gcc)
             (gnu packages zig)
             (gnu packages docker)
             (gnu packages curl)
             (gnu packages wget)
             (gnu packages rsync)
             (gnu packages version-control)
             (gnu packages java)
             (gnu packages emacs)
             (gnu packages emacs-xyz))

(use-service-modules cups
                     desktop
                     networking
                     ssh
                     xorg)

(define %packagelist-essential
  %base-packages)

(define %packagelist-networking
  (list fail2ban
        curl
        wget
        nginx))

(define %packagelist-administration
  (list btop
        fastfetch
        turbostat))

(define %packagelist-development
  (list git
        gcc
        zig
        openjdk
        docker))

(define %packagelist-emacs
  (list emacs
        emacs-guix
        emacs-company
        emacs-magit
        emacs-org
        emacs-vterm))

;;----------------------------------------------------------------------------;;
;; Software/Hardware settings.                                                ;;
;;----------------------------------------------------------------------------;;
(operating-system
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 ;; Simple one-liner definitions.                                             ;;
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 (locale "en_US.utf8")
 (timezone "America/Sao_Paulo")
 (keyboard-layout (keyboard-layout "br"))
 (host-name "guix")
 (kernel-arguments '("quiet" "modprobe.blacklist=radeon,amdgpu"))
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 ;; List of users and groups ('root' is implicit).                            ;;
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 (users
  (cons*
   (user-account (name "cezar")
                 (comment "Cezar")
                 (group "users")
                 (home-directory "/home/cezar")
                 (supplementary-groups '("wheel" "netdev" "audio" "video")))
   %base-user-accounts))
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 ;; List of system packages.                                                  ;;
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 (packages
  (append %packagelist-essential
          %packagelist-networking
          %packagelist-administration
          %packagelist-development
          %packagelist-emacs))
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 ;; List of daemon service packages.                                          ;;
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 (services
  (append
   (list (service openssh-service-type)
         (service dhcpcd-service-type)
         (service ntp-service-type))
   %base-services))
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 ;; GRUB settings.                                                            ;;
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets (list "/boot/efi"))
   (keyboard-layout keyboard-layout)))
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 ;; Swap memory partition settings.                                           ;;
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 (swap-devices
  (list
   (swap-space
    (target (uuid "1e4cff91-2358-4edb-9c27-06add6d6bf5e")))))
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 ;; FS/Mounting/Partition settings.                                           ;;
 ;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;
 (file-systems
  (cons*
   (file-system (mount-point "/boot/efi")
                (device (uuid "8203-3FCB" 'fat32))
                (type "vfat"))
   (file-system (mount-point "/")
                (device (uuid "815c6342-ab97-4bec-bb99-fe23c807982a" 'ext4))
                (type "ext4"))
   (file-system (mount-point "/home")
                (device (uuid "20fee2c0-cbbd-4e7f-a02a-68d8d39fafd1" 'ext4))
                (type "ext4"))
   %base-file-systems)))
