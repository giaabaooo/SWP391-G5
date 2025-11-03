/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/ClientSide/javascript.js to edit this template
 */
$(function () { // Đảm bảo code chạy sau khi trang đã tải xong

    var currentDeleteRequestId = null; 

    // Bắt sự kiện click .btn-delete-request
    $(document).on('click', '.btn-delete-request', function() { // Dùng document on click để bắt cả nút mới thêm (nếu có)
        var requestId = $(this).data('request-id'); 
        var requestTitle = $(this).data('request-title') || "this request"; 

        currentDeleteRequestId = requestId;
        
        $('#modalRequestTitle').text(requestTitle); // Cập nhật title trong modal
        $('#deleteRequestModal').addClass('active'); // Hiện modal
    });

    // Hàm đóng modal
    window.closeDeleteRequestModal = function() {
        $('#deleteRequestModal').removeClass('active');
        currentDeleteRequestId = null;
    };

    // Đóng modal khi click ra ngoài
    $('#deleteRequestModal').on('click', function(e) {
        if ($(e.target).is('#deleteRequestModal')) {
            closeDeleteRequestModal();
        }
    });

    // Đóng modal bằng phím ESC
    $(document).on('keydown', function(e) {
        if (e.key === 'Escape' && $('#deleteRequestModal').hasClass('active')) {
            closeDeleteRequestModal();
        }
    });

    // Xử lý nút xác nhận xóa
    $('#confirmDeleteRequestBtn').on('click', function() {
        if (currentDeleteRequestId) {
            // Tạo form động
            var form = $('<form>', {
                'method': 'POST',
                 'action': '../customer/deleteRequest'
            });
            
            var input = $('<input>', {
                'type': 'hidden',
                'name': 'id', 
                'value': currentDeleteRequestId
            });
            
            form.append(input);
            $('body').append(form);
            form.submit(); 
        }
    });

}); // Kết thúc $(function() {})