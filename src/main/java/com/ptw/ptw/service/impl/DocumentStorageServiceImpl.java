package com.ptw.ptw.service.impl;

import com.ptw.ptw.service.DocumentStorageService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class DocumentStorageServiceImpl implements DocumentStorageService {

    private final Path uploadRoot;

    public DocumentStorageServiceImpl(@Value("${ptw.upload.dir}") String uploadDirectory) {
        this.uploadRoot = Paths.get(uploadDirectory)
                .toAbsolutePath()
                .normalize();
    }

    @Override
    public String store(MultipartFile file, Long permitId) {

        if (file == null || file.isEmpty()) {
            throw new RuntimeException("Invalid file");
        }

        String originalFileName = file.getOriginalFilename();

        if (originalFileName == null || originalFileName.isBlank()) {
            throw new RuntimeException("Invalid file name");
        }

        String extension = getExtension(originalFileName);

        if (!isAllowedExtension(extension)) {
            throw new RuntimeException("Only PDF, JPG, JPEG, PNG, GIF, WEBP, DOC and DOCX files are allowed");
        }

        try {

            Path permitDirectory = uploadRoot.resolve("permits")
                                    .resolve(String.valueOf(permitId))
                                    .normalize();

            Files.createDirectories(permitDirectory);

            String storedFileName =  UUID.randomUUID() + extension;

            Path targetFile = permitDirectory.resolve(storedFileName).normalize();

            if (!targetFile.startsWith(permitDirectory)) {
                throw new RuntimeException("Invalid file path");
            }

            Files.copy(file.getInputStream(),targetFile);
            return targetFile.toString();

        } catch (IOException e) {
            throw new RuntimeException("Failed to store document",e);
        }
    }

    private String getExtension(String fileName) {
        int index = fileName.lastIndexOf('.');
        if (index == -1) {
            return "";
        }
        return fileName.substring(index)
                .toLowerCase();
    }

    private boolean isAllowedExtension(String extension) {
        return extension.equals(".pdf")
                || extension.equals(".jpg")
                || extension.equals(".jpeg")
                || extension.equals(".png")
                || extension.equals(".gif")
                || extension.equals(".webp")
                || extension.equals(".doc")
                || extension.equals(".docx");
    }
}