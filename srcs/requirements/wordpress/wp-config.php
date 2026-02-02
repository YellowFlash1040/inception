<?php
// ** MySQL settings from environment variables ** //
define('DB_NAME', getenv('MARIADB_DATA')); // default database name if not set
define('DB_USER', getenv('MARIADB_USER'));
define('DB_PASSWORD', getenv('MARIADB_ROOT_PASSWORD'));
define('DB_HOST', 'mariadb'); // name of the MariaDB service in Docker
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// ** Authentication Unique Keys and Salts ** //
// Generate your own at: https://api.wordpress.org/secret-key/1.1/salt/
define('AUTH_KEY',         'Y_?EVh^PXd8qv|3Ec/kEDFgvk{RWFHNxhHe9@b6uD=vV$i%d1IcvhNBsvH|if+_8');
define('SECURE_AUTH_KEY',  '4g!YK- Q:?yy1CSSC[ r/EpH;ap?-AJVrnYT-0rus47@#Fs-0DN&huG2|<S[,P,`');
define('LOGGED_IN_KEY',    'nrQs6:)i HuW&[iIL&E[1iaJrR)Pxp-6-4&(SI[=HUIc-QIY5uG|Jv=N).8R.F%T');
define('NONCE_KEY',        '<sp(/o^,`d$`<cy gZR:#=xOM/JBGxo`nk;U|,C v98?k@@0+j]#o$/dR>$zmTzb');
define('AUTH_SALT',        's54soDw^3nQs?4vr[iPUNP3$**`]NSYJE|ij-s-dYn*wCA_OGj#=5oC[B$=A>w{V');
define('SECURE_AUTH_SALT', 'HvdR*<q+=6NMQc||^N|O6u^}70sW&!Ti(DGsjznVuMw3gpq]/hn++u*>l$fujp^)');
define('LOGGED_IN_SALT',   'MVa;IA1Yf/ng_,dH!bF4ORRdDcp/yY-*F.-&]@v-I7SS1]YD1z5b~Km<Pk-@ks4n');
define('NONCE_SALT',       '*Kx0s+}j}-c($k~}lke&%<YI5mWf+ZXbJL[MNpztx)9*#U$/MZGHy2RL^Ul-qg[f');

// Table prefix
$table_prefix = 'wp_';

// WordPress debugging
define('WP_DEBUG', false);

// Absolute path to the WordPress directory
if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/');
}

// Sets up WordPress vars and included files
require_once(ABSPATH . 'wp-settings.php');
