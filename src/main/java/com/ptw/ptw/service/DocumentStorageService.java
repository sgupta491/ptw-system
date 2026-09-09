package com.ptw.ptw.service;

import org.springframework.web.multipart.MultipartFile;

public interface DocumentStorageService {

    String store(MultipartFile file, Long permitId);
}
