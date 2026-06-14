return {
    server = 'zls',
    cmd = { 'zls' },
    settings = {
        filetypes = { 'zig', 'zir' },
        root_markers = { 'build.zig' },
        single_file_support = false,
        workspace_required = false,
    },
}
