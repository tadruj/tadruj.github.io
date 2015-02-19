<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', getenv('GNOWBE_DB_NAME'));

/** MySQL database username */
define('DB_USER', getenv('GNOWBE_DB_USER'));

/** MySQL database password */
define('DB_PASSWORD', getenv('GNOWBE_DB_PASSWORD'));

/** MySQL hostname */
define('DB_HOST', getenv('GNOWBE_DB_HOST'));

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '(N,Y+fBr|+Z3E.-?S`n`c.69&wR~Ttwe 71|;<D$F_E||:gGr*xG)ci#H%!!w{;n');
define('SECURE_AUTH_KEY',  'mi=wS-mmDp/6v:^lO2T$h6G8B|>rnhx2>wcFc.{u+arS$z-k*clC$Pks+n6w9L6{');
define('LOGGED_IN_KEY',    '[+l1o6B0}-<aG50c]lL0,szT=E`5c.!EF$hu|Q+rYSsHY+EQCMw,]&(**Jf|2TmL');
define('NONCE_KEY',        '@=p->tzWOTZCUy^)F8Y$2+.lTn@XyHC*(x~x8b&C<?e-$;kD!lZFexyE|h{2jSm}');
define('AUTH_SALT',        '&hwME|9+ytQQg|+T:B18i9&M(|eb_?h$sE[G}C<~=qhl+Wub`$,P+?UH<^,)5U$4');
define('SECURE_AUTH_SALT', '-ZSh}EQ~u)Z+[Y]B_%Q}c*;ENu#FFg-223[b<h-|R,S>Hp,{#T+;`N,+J{;9<U/P');
define('LOGGED_IN_SALT',   '#<-iS!lN-KWpBe_a]psYz0G<+PXEg06&E-KQvy0{G|qW5:<c?`BI{@VJbtk,~Vj_');
define('NONCE_SALT',       'Bkq^Ef+CPuW~wvk>FNlsJjlOTGVG>=S_^v.;8O+gSebwZ2X}64[D~X_uQlGp0xQ:');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
