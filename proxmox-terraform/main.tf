# main.tf - Основной файл конфигурации инфраструктуры

# Ресурс: создание виртуальной машины в Proxmox
resource "proxmox_vm_qemu" "test_vm" {
  # Уникальный ID виртуальной машины в Proxmox (101-999999999)
  vmid = 1001
  
  # Имя виртуальной машины (отображается в веб-интерфейсе)
  name = "terraform-test-vm"
  
  # На какой ноде Proxmox создавать ВМ
  target_node = var.proxmox_node
  
  # Включаем QEMU agent для управления ВМ извне
  agent = 1
  
  # Настройки процессора
  cores   = 2      # Количество ядер
  sockets = 1      # Количество сокетов
  cpu     = "host" # Тип CPU (можно использовать 'kvm64', 'host' и др.)
  
  # Настройки памяти
  memory = 4096  # Память в MB
  
  # Настройки BIOS/UEFI
  bios    = "seabios"  # seabios или ovmf (для UEFI)
  machine = "q35"      # Тип машины (q35 или i440fx)
  
  # Настройки загрузки
  boot     = "order=scsi0"  # С какого диска загружаться
  bootdisk = "scsi0"
  
  # Клонирование из шаблона (ID 9000, который мы создали)
  clone = "ubuntu-2204-cloudinit"
  full_clone = true  # Полный клон (не связанный с шаблоном)
  
  # Настройки SCSI контроллера
  scsihw = "virtio-scsi-pci"
  
  # Статус ВМ после создания (running - запущена)
  onboot  = true      # Запускать при загрузке хоста
  oncreate = true     # Запустить сразу после создания
  vm_state = "running"
  
  # Настройки Cloud-Init
  ciuser     = "admin"                    # Имя пользователя
  cipassword = "SecurePassword123!"       # Пароль пользователя
  sshkeys    = var.ssh_public_key         # SSH ключ для доступа
  
  # Настройки сети через Cloud-Init
  ipconfig0 = "ip=${cidrhost(var.network_config.subnet, 150)}/24,gw=${var.network_config.gateway}"
  
  # Настройки DNS
  nameserver = var.network_config.dns
  
  # Опции Cloud-Init
  cicustom = ""          # Кастомные файлы cloud-init (если нужны)
  searchdomain = "local" # Домен для поиска
  
  # Настройка диска
  disk {
    # SCSI диск 0
    slot     = 0
    size     = "32G"          # Размер диска
    storage  = "local-lvm"    # Хранилище
    type     = "scsi"
    format   = "raw"          # Формат диска
    ssd      = 1              # Эмулировать SSD
    discard  = "on"           # Включить TRIM
    iothread = 1              # Включить IO threads для производительности
  }
  
  # Настройка сети
  network {
    model    = "virtio"       # Модель сетевой карты
    bridge   = "vmbr0"        # Используемый мост
    firewall = false          # Включить файрвол Proxmox
    tag      = -1             # VLAN tag (-1 = без VLAN)
  }
  
  # Настройки VGA (видео)
  vga {
    type   = "std"     # Тип VGA (std, vmware, qxl и др.)
    memory = 32        # Память VGA в MB
  }
  
  # Настройки серийного порта (для консоли)
  serial {
    id   = 0
    type = "socket"
  }
  
  # Защита от случайного удаления
  # Раскомментируйте, если хотите защитить ВМ от terraform destroy
  # lifecycle {
  #   prevent_destroy = true
  # }
  
  # Метаданные (необязательно)
  tags = "terraform,test,ubuntu"
  
  # Описание ВМ (видно в веб-интерфейсе)
  description = "Тестовая ВМ созданная через Terraform\nДата создания: ${formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())}"
}