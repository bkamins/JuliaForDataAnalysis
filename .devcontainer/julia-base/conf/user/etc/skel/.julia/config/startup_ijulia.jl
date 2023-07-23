if !in(MIME("application/pdf"), IJulia.ijulia_mime_types)
    IJulia.register_mime(MIME("application/pdf"))
end
