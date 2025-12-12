# variables.tf - Определение переменных для нашего проекта

# Переменная для пароля Proxmox
variable "proxmox_password" {
  description = "Пароль пользователя terraform@pve в Proxmox"
  type        = string
  sensitive   = true  # Эта переменная будет скрыта в выводе
}

# Переменная для публичного SSH ключа
variable "ssh_public_key" {
  description = "Публичный SSH ключ для доступа к создаваемым ВМ"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDE..." # ВСТАВЬТЕ СВОЙ КЛЮЧ
}

# Переменная для IP адреса Proxmox
variable "proxmox_host" {
  description = "IP адрес или доменное имя сервера Proxmox"
  type        = string
  default     = "192.168.0.98"
}

# Переменная для имени ноды Proxmox
variable "proxmox_node" {
  description = "Имя ноды Proxmox, на которой будут создаваться ВМ"
  type        = string
  default     = "pve"  # Обычно 'pve' для одиночного сервера
}

# Переменная для сети
variable "network_config" {
  description = "Настройки сети для создаваемых ВМ"
  type = object({
    gateway = string
    subnet  = string
    dns     = string
  })
  default = {
    gateway = "192.168.0.1"
    subnet  = "192.168.0.0/24"
    dns     = "8.8.8.8"
  }
}