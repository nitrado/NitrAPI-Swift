/// Type of access a user has on a service
public enum Role: String {
    
    /// Owner of this server
    case ROLE_OWNER
    
    /// Can change server game
    case ROLE_GAMESERVER_CHANGE_GAME
    
    /// Can use generic control commands
    case ROLE_WEBINTERFACE_GENERAL_CONTROL
    
    /// Can view current backups
    case ROLE_WEBINTERFACE_BACKUPS_READ
    
    /// Can restore available backups
    case ROLE_WEBINTERFACE_BACKUPS_WRITE
    
    /// Can view the debug console
    case ROLE_WEBINTERFACE_DEBUG_CONSOLE_READ
    
    /// Can use the debug console
    case ROLE_WEBINTERFACE_DEBUG_CONSOLE_WRITE
    
    /// Can view/download files from the file server
    case ROLE_WEBINTERFACE_FILEBROWSER_READ
    
    /// Can change/upload files via file server
    case ROLE_WEBINTERFACE_FILEBROWSER_WRITE
    
    /// Can see ftp access credentials
    case ROLE_WEBINTERFACE_FTP_CREDENTIALS_READ
    
    /// Can change ftp access credentials
    case ROLE_WEBINTERFACE_FTP_CREDENTIALS_WRITE
    
    /// Allows a user to send RCON-commands that retrieve infos
    case ROLE_WEBINTERFACE_GAME_RCON_READ
    
    /// Allows a user to send RCON-commands that change settings
    case ROLE_WEBINTERFACE_GAME_RCON_WRITE
    
    /// Can see webinterface logs
    case ROLE_WEBINTERFACE_LOGS_READ
    
    /// Can view MySQL access credentials
    case ROLE_WEBINTERFACE_MYSQL_CREDENTIALS_READ
    
    /// Can change MySQL access credentials
    case ROLE_WEBINTERFACE_MYSQL_CREDENTIALS_WRITE
    
    /// Can view scheduled server restarts
    case ROLE_WEBINTERFACE_SCHEDULED_RESTART_READ
    
    /// Can edit scheduled server restarts
    case ROLE_WEBINTERFACE_SCHEDULED_RESTART_WRITE
    
    /// Has access to server settings
    case ROLE_WEBINTERFACE_SETTINGS_READ
    
    /// Can change server settings
    case ROLE_WEBINTERFACE_SETTINGS_WRITE
    
    /// Can authorize the support
    case ROLE_SUPPORT_AUTHORIZATION
}
