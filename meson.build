project('malcontent', 'c',
  version : '0.13.0',
  meson_version : '>= 1.2.0',
  license: ['LGPL-2.1-or-later', 'GPL-2.0-or-later'],
  default_options : [
    'buildtype=debugoptimized',
    'warning_level=2',
    'c_std=gnu11',
  ]
)

gnome = import('gnome')
i18n = import('i18n')
pkgconfig = import('pkgconfig')

meson_make_symlink = join_paths(meson.current_source_dir(), 'tools', 'meson-make-symlink.py')
po_dir = join_paths(meson.current_source_dir(), 'po')

prefix = get_option('prefix')
bindir = join_paths(prefix, get_option('bindir'))
datadir = join_paths(prefix, get_option('datadir'))
libdir = join_paths(prefix, get_option('libdir'))
libexecdir = join_paths(prefix, get_option('libexecdir'))
includedir = join_paths(prefix, get_option('includedir'))

# FIXME: This isn’t exposed in accountsservice.pc
# See https://gitlab.freedesktop.org/accountsservice/accountsservice/merge_requests/16
accountsserviceinterfacesdir = join_paths(datadir, 'accountsservice', 'interfaces')

# FIXME: pam.pc doesn’t exist
pamlibdir = get_option('pamlibdir')
if pamlibdir == ''
  pamlibdir = join_paths(libdir, 'security')
endif

dbus = dependency('dbus-1')
dbusinterfacesdir = dbus.get_variable(pkgconfig: 'interfaces_dir',
  pkgconfig_define: ['datadir', datadir])

polkit_gobject = dependency('polkit-gobject-1')
polkitpolicydir = polkit_gobject.get_variable(pkgconfig: 'policydir',
  pkgconfig_define: ['prefix', prefix])

config_h = configuration_data()
config_h.set_quoted('GETTEXT_PACKAGE', 'malcontent')
config_h.set_quoted('PACKAGE_LOCALE_DIR', join_paths(get_option('prefix'), get_option('localedir')))
config_h.set_quoted('PAMLIBDIR', pamlibdir)
config_h.set_quoted('VERSION', meson.project_version())
configure_file(
  output: 'config.h',
  configuration: config_h,
)
root_inc = include_directories('.')

# Enable warning flags
test_c_args = [
  '-fno-strict-aliasing',
  '-fstack-protector-strong',
  '-Waggregate-return',
  '-Wunused',
  '-Warray-bounds',
  '-Wcast-align',
  '-Wclobbered',
  '-Wno-declaration-after-statement',
  '-Wdiscarded-qualifiers',
  '-Wduplicated-branches',
  '-Wduplicated-cond',
  '-Wempty-body',
  '-Wformat=2',
  '-Wformat-nonliteral',
  '-Wformat-security',
  '-Wformat-signedness',
  '-Wignored-qualifiers',
  '-Wimplicit-function-declaration',
  '-Wincompatible-pointer-types',
  '-Wincompatible-pointer-types-discards-qualifiers',
  '-Winit-self',
  '-Wint-conversion',
  '-Wlogical-op',
  '-Wmisleading-indentation',
  '-Wmissing-declarations',
  '-Wmissing-format-attribute',
  '-Wmissing-include-dirs',
  '-Wmissing-noreturn',
  '-Wmissing-parameter-type',
  '-Wmissing-prototypes',
  '-Wnested-externs',
  '-Wno-error=cpp',
  '-Wmissing-field-initializers',
  '-Wno-suggest-attribute=format',
  '-Wno-unused-parameter',
  '-Wnull-dereference',
  '-Wold-style-definition',
  '-Woverflow',
  '-Woverride-init',
  '-Wparentheses',
  '-Wpointer-arith',
  '-Wredundant-decls',
  '-Wreturn-type',
  '-Wshadow',
  '-Wsign-compare',
  '-Wno-error=strict-aliasing',
  '-Wstrict-prototypes',
  '-Wswitch-default',
  '-Wswitch-enum',
  '-Wtype-limits',
  '-Wundef',
  '-Wuninitialized',
  '-Wunused-but-set-variable',
  '-Wunused-result',
  '-Wunused-variable',
  '-Wwrite-strings'
]
cc = meson.get_compiler('c')
add_project_arguments(cc.get_supported_arguments(test_c_args), language: 'c')

enable_installed_tests = get_option('installed_tests')
test_template = files('template.test.in')
test_env = [
  'G_DEBUG=gc-friendly,fatal-warnings',
  'MALLOC_CHECK_=2',
  'LC_ALL=C.UTF-8',
]

# Keep in sync with GTK version dependency below
add_project_arguments([
  '-DGDK_VERSION_MIN_REQUIRED=GDK_VERSION_4_12',
  '-DGDK_VERSION_MAX_ALLOWED=G_ENCODE_VERSION(4,14)'
], language: 'c')

subdir('accounts-service')
subdir('help')
if not get_option('use_system_libmalcontent')
  subdir('libmalcontent')
else
  libmalcontent_api_version = '0'
  libmalcontent_dep = dependency('malcontent-' + libmalcontent_api_version, version: meson.project_version())
  libmalcontent_gir = ['Malcontent-' + libmalcontent_api_version,
                       'Malcontent-' + libmalcontent_api_version + '.typelib']
endif
if get_option('ui').enabled()
  # Keep in sync with GDK_VERSION_MIN_REQUIRED etc above
  gtk_dep = dependency('gtk4', version: '>= 4.12')
  libadwaita_dep = dependency(
    'libadwaita-1',
    version: '>= 1.1',
    fallback: ['libadwaita', 'libadwaita_dep'],
    default_options: ['examples=false', 'introspection=disabled', 'tests=false', 'vapi=false'],
  )
  subdir('libmalcontent-ui')
endif
subdir('malcontent-client')
if get_option('ui').enabled()
  subdir('malcontent-control')

  gnome.post_install(
    gtk_update_icon_cache: true,
    update_desktop_database: true,
  )
endif
subdir('pam')
subdir('po')
