package com.ptw.ptw.service.impl;

import com.ptw.ptw.dto.ChecklistFieldOption;
import com.ptw.ptw.dto.ChecklistOption;
import com.ptw.ptw.entity.ChecklistFieldMaster;
import com.ptw.ptw.entity.ChecklistMaster;
import com.ptw.ptw.entity.PermitTypeChecklist;
import com.ptw.ptw.repository.ChecklistFieldMasterRepository;
import com.ptw.ptw.repository.PermitTypeChecklistRepository;
import com.ptw.ptw.service.ChecklistService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class ChecklistServiceImpl implements ChecklistService {

    private final PermitTypeChecklistRepository permitTypeChecklistRepository;
    private final ChecklistFieldMasterRepository checklistFieldMasterRepository;

    @Override
    public List<ChecklistOption> findByPermitType(Long permitTypeId) {

        return permitTypeChecklistRepository.findByPermitType_IdOrderByDisplayOrderAsc(permitTypeId)
                .stream()
                .filter(mapping -> Boolean.TRUE.equals(mapping.getChecklist()
                        .getActive()))
                .map(this::mapToOption)
                .toList();
        
    }

    private ChecklistOption  mapToOption(PermitTypeChecklist mapping) {

        ChecklistMaster checklist = mapping.getChecklist();

        List<ChecklistFieldOption> fields = checklistFieldMasterRepository.findByChecklist_IdAndActiveTrueOrderByDisplayOrderAsc(
                checklist.getId())
                .stream()
                .map(this::mapField)
                .toList();

        return  ChecklistOption.builder()
                .id(checklist.getId())
                .questionCode(checklist.getQuestionCode())
                .questionText(checklist.getQuestionText())
                .section(checklist.getSection())
                .displayOrder(checklist.getDisplayOrder())
                .fields(fields)
                .itemType(checklist.getItemType())
                .build();
    }

    private ChecklistFieldOption  mapField( ChecklistFieldMaster field) {

        return ChecklistFieldOption.builder()
                .id(field.getId())
                .fieldCode( field.getFieldCode())
                .fieldLabel(field.getFieldLabel())
                .fieldType(field.getFieldType())
                .required(field.getRequired())
                .displayOrder(field.getDisplayOrder())
                .build();
    }



}
