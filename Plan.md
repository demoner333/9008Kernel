# Plan of 32-bit Hybrid Kernel

 - "*" = maybe


  | Kernel space   | 
  | -------------- |
  | IDT            | 
  | GDT            |   
  | PS/2           |   
  | VGA            |
  | ATA/Pio        |
  | Task system    |
  | int 0x80       |
  | Filesystem     |
  | ELF Loader     |

          |

  | Shared Memory  |
  | -------------- |
  | Global info    |
  | Ring 3 comm.   |
          |
  | User Space     |
  | -------------- |
  | Framebuffer    |
  | ACPI        *  |
  | USB Driver  *  |
  | Ethernet    *  |
  | User system *  |
  | Shell          |


## Plan of load system

### Ring 0

1. Bootloader (GRUB)
2. Init GDT (Global descriptor Table)
3. Init IDT (Interrupt Descriptor Table)
4. init VGA (80x25)
5. Init PS/2 (Keyboard)
6. Init ATA/Pio (Disk Driver)
7. Scheduler
8. Run /init

### Ring 3 

9. Init Framebuffer
10. Init ACPI *
11. Init USB *
12. Init Ethernet *
13. Setup users
14. Run Shell
