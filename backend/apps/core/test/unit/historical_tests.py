import json
from rest_framework import status
from django.test import TestCase, Client
from django.urls import reverse
from core.models import Historical
from core.serializers import HistoricalSerializer
from faker import Faker
import random

class HistoricalTests(TestCase):
    def setUp(self):
        self.faker = Faker('pt_BR')
        self.client = Client()

        self.historical_1 = Historical.objects.create(create_at = self.faker.date(), modified_at = self.faker.date())
        self.historical_2 = Historical.objects.create(create_at = self.faker.date(), modified_at = self.faker.date())
        self.historical_3 = Historical.objects.create(create_at = self.faker.date(), modified_at = self.faker.date())

        self.valid_payload = {
            'create_at' : self.faker.date(),'modified_at' : self.faker.date()
        }
        self.invalid_payload = {
            'create_at' : self.faker.date(),'modified_at' : self.faker.date()
        }

    def test_valid_create(self):
        response = self.client.post(
            reverse('historical-api-list'),
            data=json.dumps(self.valid_payload),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_invalid_create(self):
        response = self.client.post(
            reverse('historical-api-list'),
            data=json.dumps(self.invalid_payload),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_valid_upload(self):
        response = self.client.put(
            reverse('historical-detail',
            kwargs={'pk': self.historical_1.id}),
            data=json.dumps(self.valid_payload),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_invalid_upload(self):
        response = self.client.put(
            reverse('historical-detail',
            kwargs={'pk': self.historical_1.id}),
            data=json.dumps(self.invalid_payload),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    # retornando todos os elementos    
    def test_retrieve_all(self):
        response   = self.client.get(reverse('historical-api-list'))
        data       = Historical.objects.all()
        serializer = HistoricalSerializer(data, context={'request': None}, many=True)
        # Aqui deve comparar todos os compos do objeto com serialização
        self.assertEqual(response.data, serializer.data)

        self.assertIsNotNone(response.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    # retornando um elemento
    def test_valid_get_element(self):
        response = self.client.get(reverse('historical-detail',kwargs={'pk': self.historical_1.id}))
        data = Historical.objects.get(pk=self.condicao_1.id)
        # Aqui deve comparar todos os campos do objeto com serialização
        self.assertEqual(str(data.uuid),response.data['uuid'])
        self.assertIsNotNone(response.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    # erro ao retornar um elemento invalido
    def test_invalid_get_element(self):
        response = self.client.get(reverse('historical-detail',kwargs={'pk': 666}))
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    # Delete um elemento valido
    def test_valid_delete(self):
        response = self.client.delete(reverse('historical-detail',kwargs={'pk': self.historical_1.id}))
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    # Delete um elemento valido
    def test_invalid_delete(self):
        response = self.client.delete(reverse('historical-detail',kwargs={'pk': 666}))
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
