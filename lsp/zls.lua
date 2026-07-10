return {
    server = 'zls',
    cmd = { 'zls' },
    filetypes = { 'zig', 'zir' },
    root_markers = { 'build.zig.zon', 'build.zig', '.git' },
    single_file_support = false,
    workspace_required = false,
}
