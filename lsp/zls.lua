return {
    server = 'zls',
    cmd = { 'zls' },
    settings = {
        filetypes = { 'zig', 'zir' },
        root_markers = { 'zls.json', 'build.zig', '.git' },
        single_file_support = true,
        workspace_required = false,
    },
}
