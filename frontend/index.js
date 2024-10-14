import { backend } from 'declarations/backend';

let items = [];

async function fetchItems() {
    showLoading();
    items = await backend.getItems();
    renderItems();
    hideLoading();
}

function renderItems() {
    const list = document.getElementById('shoppingList');
    list.innerHTML = '';
    items.forEach(item => {
        const li = document.createElement('li');
        li.innerHTML = `
            <input type="checkbox" ${item.completed ? 'checked' : ''}>
            <span class="${item.completed ? 'completed' : ''}">${item.text}</span>
            <button class="delete-btn"><i data-feather="trash-2"></i></button>
        `;
        li.querySelector('input').addEventListener('change', () => toggleItem(item.id));
        li.querySelector('.delete-btn').addEventListener('click', () => deleteItem(item.id));
        list.appendChild(li);
    });
    feather.replace();
}

async function addItem() {
    const input = document.getElementById('newItem');
    const text = input.value.trim();
    if (text) {
        showLoading();
        await backend.addItem(text);
        input.value = '';
        await fetchItems();
        hideLoading();
    }
}

async function toggleItem(id) {
    showLoading();
    await backend.toggleItem(id);
    await fetchItems();
    hideLoading();
}

async function deleteItem(id) {
    showLoading();
    await backend.deleteItem(id);
    await fetchItems();
    hideLoading();
}

function showLoading() {
    document.getElementById('loadingSpinner').classList.remove('hidden');
}

function hideLoading() {
    document.getElementById('loadingSpinner').classList.add('hidden');
}

document.getElementById('addButton').addEventListener('click', addItem);
document.getElementById('newItem').addEventListener('keypress', (e) => {
    if (e.key === 'Enter') addItem();
});

fetchItems();
feather.replace();
