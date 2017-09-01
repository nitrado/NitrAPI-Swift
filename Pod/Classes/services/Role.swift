/// Type of access a user has on a service
public class Role: Value {
    
    /// Owner of this server
    public static let ROLE_OWNER = Role("ROLE_OWNER")
    
    /// Can change server game
    public static let ROLE_GAMESERVER_CHANGE_GAME = Role("ROLE_GAMESERVER_CHANGE_GAME")
    
    /// Can use generic control commands
    public static let ROLE_WEBINTERFACE_GENERAL_CONTROL = Role("ROLE_WEBINTERFACE_GENERAL_CONTROL")
    
    /// Can view current backups
    public static let ROLE_WEBINTERFACE_BACKUPS_READ = Role("ROLE_WEBINTERFACE_BACKUPS_READ")
    
    /// Can restore available backups
    public static let ROLE_WEBINTERFACE_BACKUPS_WRITE = Role("ROLE_WEBINTERFACE_BACKUPS_WRITE")
    
    /// Can view the debug console
    public static let ROLE_WEBINTERFACE_DEBUG_CONSOLE_READ = Role("ROLE_WEBINTERFACE_DEBUG_CONSOLE_READ")
    
    /// Can use the debug console
    public static let ROLE_WEBINTERFACE_DEBUG_CONSOLE_WRITE = Role("ROLE_WEBINTERFACE_DEBUG_CONSOLE_WRITE")
    
    /// Can view/download files from the file server
    public static let ROLE_WEBINTERFACE_FILEBROWSER_READ = Role("ROLE_WEBINTERFACE_FILEBROWSER_READ")
    
    /// Can change/upload files via file server
    public static let ROLE_WEBINTERFACE_FILEBROWSER_WRITE = Role("ROLE_WEBINTERFACE_FILEBROWSER_WRITE")
    
    /// Can see ftp access credentials
    public static let ROLE_WEBINTERFACE_FTP_CREDENTIALS_READ = Role("ROLE_WEBINTERFACE_FTP_CREDENTIALS_READ")
    
    /// Can change ftp access credentials
    public static let ROLE_WEBINTERFACE_FTP_CREDENTIALS_WRITE = Role("ROLE_WEBINTERFACE_FTP_CREDENTIALS_WRITE")
    
    /// Allows a user to send RCON-commands that retrieve infos
    public static let ROLE_WEBINTERFACE_GAME_RCON_READ = Role("ROLE_WEBINTERFACE_GAME_RCON_READ")
    
    /// Allows a user to send RCON-commands that change settings
    public static let ROLE_WEBINTERFACE_GAME_RCON_WRITE = Role("ROLE_WEBINTERFACE_GAME_RCON_WRITE")
    
    /// Can see webinterface logs
    public static let ROLE_WEBINTERFACE_LOGS_READ = Role("ROLE_WEBINTERFACE_LOGS_READ")
    
    /// Can view MySQL access credentials
    public static let ROLE_WEBINTERFACE_MYSQL_CREDENTIALS_READ = Role("ROLE_WEBINTERFACE_MYSQL_CREDENTIALS_READ")
    
    /// Can change MySQL access credentials
    public static let ROLE_WEBINTERFACE_MYSQL_CREDENTIALS_WRITE = Role("ROLE_WEBINTERFACE_MYSQL_CREDENTIALS_WRITE")
    
    /// Can view scheduled server restarts
    public static let ROLE_WEBINTERFACE_SCHEDULED_RESTART_READ = Role("ROLE_WEBINTERFACE_SCHEDULED_RESTART_READ")
    
    /// Can edit scheduled server restarts
    public static let ROLE_WEBINTERFACE_SCHEDULED_RESTART_WRITE = Role("ROLE_WEBINTERFACE_SCHEDULED_RESTART_WRITE")
    
    /// Has access to server settings
    public static let ROLE_WEBINTERFACE_SETTINGS_READ = Role("ROLE_WEBINTERFACE_SETTINGS_READ")
    
    /// Can change server settings
    public static let ROLE_WEBINTERFACE_SETTINGS_WRITE = Role("ROLE_WEBINTERFACE_SETTINGS_WRITE")
    
    /// Can edit the server page
    public static let ROLE_WEBINTERFACE_SERVERPAGE_EDIT = Role("ROLE_WEBINTERFACE_SERVERPAGE_EDIT")
    
    /// Can execute live command
    public static let ROLE_WEBINTERFACE_LIVE_COMMANDS = Role("ROLE_WEBINTERFACE_LIVE_COMMANDS")
    
    /// Can authorize the support
    public static let ROLE_SUPPORT_AUTHORIZATION = Role("ROLE_SUPPORT_AUTHORIZATION")
}
