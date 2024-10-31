-- Вывести количество объектов в массиве
SELECT id, jsonb_array_length(attributes) length
FROM old_asufi_migration_document
order by length desc;

-- Вывод всех значений поля определённого объекта массива
SELECT recognized_document.document_kind_code,
       attr ->> 'name' AS attribute_name
FROM public.recognized_document,
    jsonb_array_elements(metadata -> 'attributes') AS attr -- замените на ваше поле jsonb
where id = 'd8f18715-273b-4763-aa7a-7bcf62c4a731'
order by attribute_name;

