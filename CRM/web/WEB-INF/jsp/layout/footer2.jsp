<%-- 
    Document   : footer2
    Created on : Oct 3, 2025, 7:15:49 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
</section>
        <div class="footer-main">Copyright &copy; Warehouse Management System, 2024</div>
    </aside>
</div>

<!-- SCRIPTS -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="../js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
<script src="../js/bootstrap.min.js" type="text/javascript"></script>
<script src="../js/daterangepicker.js" type="text/javascript"></script>
<script src="../js/chart.js" type="text/javascript"></script>
<script src="../js/icheck.min.js" type="text/javascript"></script>
<script src="../js/fullcalendar.js" type="text/javascript"></script>
<script src="../js/app.js" type="text/javascript"></script>
<script src="../js/dashboard.js" type="text/javascript"></script>

<script>
    $(function() {
        // Initialize iCheck for checkboxes
        $('input[type="checkbox"].flat-grey').iCheck({
            checkboxClass: 'icheckbox_flat-grey'
        });

        // Handle checkbox events
        $('input').on('ifChecked', function(event) {
            $(this).parents('li').addClass("task-done");
        });
        $('input').on('ifUnchecked', function(event) {
            $(this).parents('li').removeClass("task-done");
        });

        // Handle approve/reject buttons
        $('.btn-approve').click(function() {
            var requestId = $(this).closest('.request-item').find('.request-header').text();
            if (confirm('Are you sure you want to approve ' + requestId + '?')) {
                // Add AJAX call to approve request
                $(this).closest('.request-item').fadeOut();
            }
        });

        $('.btn-reject').click(function() {
            var requestId = $(this).closest('.request-item').find('.request-header').text();
            if (confirm('Are you sure you want to reject ' + requestId + '?')) {
                // Add AJAX call to reject request
                $(this).closest('.request-item').fadeOut();
            }
        });

        // Auto-refresh statistics every 30 seconds
        setInterval(function() {
            // You can add AJAX calls here to refresh data
            console.log('Refreshing warehouse data...');
        }, 30000);
    });
</script>

</body>
</html>
