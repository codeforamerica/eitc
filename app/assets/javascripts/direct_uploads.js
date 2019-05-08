var directUpload = (function () {
    return {
        init: function () {
            var addDeleteFileListener = function() {
                $('.delete-file-link').each(function (index, deleteFileLink) {
                    deleteFileLink.addEventListener('click', function (e) {
                        deleteFileLink.closest('.uploaded-file-detail').remove();
                    });
                });
            };


            $('input[type=file]').each(function (index, fileInput) {
                const url = fileInput.dataset.directUploadUrl;

                $('.upload-file-button').each(function (index, uploadFileButton) {
                    uploadFileButton.addEventListener('click', function (e) {
                        e.preventDefault();
                        fileInput.click();
                    });
                });

                fileInput.addEventListener('change', function (e) {
                    $('button[type="submit"]').prop('disabled', true);
                    $('.verification-upload-icon').hide();

                    for(let i=0,file;file=this.files[i];i++) {
                        var context = {
                            id: 'uploaded-file-detail-' + i
                        };
                        var uploadedFileDetailHtml = HandlebarsTemplates['file_uploading'](context);
                        $('.uploaded-files').append(uploadedFileDetailHtml);
                        const upload = new ActiveStorage.DirectUpload(file, url);

                        upload.create(function (error, blob) {
                            var context = {
                                filename: blob.filename,
                                signedId: blob.signed_id,
                                isPdf: (blob.content_type === "application/pdf"),
                                inputName: fileInput.name
                            };
                            var uploadedFileDetailHtml = HandlebarsTemplates['uploaded_file_detail'](context);
                            $('#uploaded-file-detail-' + i).replaceWith(uploadedFileDetailHtml);
                            addDeleteFileListener();

                            if ($('h4.loading').length == 0) {
                                $('button[type="submit"]').prop('disabled', false);
                            }
                        });
                    };
                    fileInput.value = null;
                });
            });

            addDeleteFileListener();
        }
    }
})();

$(document).ready(function () {
    directUpload.init();
});
