import os
import json
import logging
from django.conf import settings
from django.core.management.base import BaseCommand
from apps.questionnaire.models import AdoptedLevel, Statement
from apps.sth.models import Stage

logger = logging.getLogger(__name__)

class Command(BaseCommand):
    help = 'Popula o banco de dados com os dados iniciais necessarios para o Questionario (Niveis de adocao, Estagios StH e Perguntas).'

    def handle(self, *args, **options):
        self.stdout.write(self.style.NOTICE('Iniciando o carregamento dos dados base do questionario...'))

        # 1. Popular Adopted Levels
        adopted_levels = [
            {"name": "Not adopted", "percentage": 0, "description": "A pratica nao e adotada."},
            {"name": "Abandoned", "percentage": 10, "description": "A pratica foi tentada, mas abandonada."},
            {"name": "Realized at project/product level", "percentage": 30, "description": "Adotado em alguns projetos ou produtos específicos."},
            {"name": "Realized at process level", "percentage": 60, "description": "Padronizado como um processo dentro da organizacao."},
            {"name": "Institutionalized", "percentage": 100, "description": "Totalmente institucionalizado e enraizado na cultura da empresa."},
        ]

        for level_data in adopted_levels:
            AdoptedLevel.objects.get_or_create(
                name=level_data["name"],
                defaults={
                    "percentage": level_data["percentage"],
                    "description": level_data["description"]
                }
            )

        # 2. Popular StH Stages
        sth_stages = [
            {"name": "Traditional Development", "description": "Longos ciclos de desenvolvimento."},
            {"name": "Agile R&D Organization", "description": "Práticas ageis em desenvolvimento, mas ao redor (produto/teste) continua tradicional."},
            {"name": "Continuous Integration", "description": "Integracao frequente de codigo, builds e testes automatizados."},
            {"name": "Continuous Deployment", "description": "Implantacao frequente para o cliente, ciclos curtos baseados em feedback."},
            {"name": "R&D as an Experiment System", "description": "Ciclo de desenvolvimento tratado como experimento contínuo com o cliente."}
        ]
        
        stage_instances = {}
        for stage_data in sth_stages:
            stage, _ = Stage.objects.get_or_create(
                name=stage_data["name"],
                defaults={"description": stage_data["description"]}
            )
            stage_instances[stage_data["name"]] = stage

        # 3. Extrair e criar as Perguntas (Statements) do JSON
        json_file_path = os.path.join(settings.BASE_DIR, 'fixtures', 'questions.json')
        
        if not os.path.exists(json_file_path):
            self.stdout.write(self.style.ERROR(f'Arquivo de perguntas nao encontrado em: {json_file_path}'))
            return

        statements_created = 0
        with open(json_file_path, 'r', encoding='utf-8') as f:
            questions = json.load(f)
            
            for q in questions:
                stage_fk = stage_instances.get(q["stage"])
                
                _, created = Statement.objects.get_or_create(
                    code=q["code"],
                    defaults={
                        "text": q["text"],
                        "sth_stage": stage_fk
                    }
                )
                if created:
                    statements_created += 1

        self.stdout.write(self.style.SUCCESS(f'Carga finalizada! {statements_created} novas perguntas (statements) inseridas.'))
