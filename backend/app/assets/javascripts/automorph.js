function show_result(data) {
    const results = $('#results');
    results.empty();
    if (data.error) {
        results.text(data.error);
        return;
    }

    let table = '<table>';
    table += '<tr>';
    table += '<td>№</td>';
    table += '<td>Квадрат числа</td>';
    table += '<td>Число</td>';
    table += '</tr>';
    data.result.forEach((num, i) => {
        table += '<tr>';
        table += '<td>' + (i + 1) + '</td><td>' + Math.pow(num, 2) + '</td><td>' + num + '</td>';
        table += '</tr>';
    });
    table += '</table>';

    results.append(table);
}

function main() {
    $('#input_form').bind('ajax:success', function (xrs, data, status) {
        show_result(xrs.detail[0]);
    });
}

// Start listeners
$(document).ready(main);
$(document).on('turbolinks:load', main);